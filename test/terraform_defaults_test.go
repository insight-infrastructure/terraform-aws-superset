package test

import (
	"crypto/tls"
	"fmt"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"gotest.tools/assert"
	"io/ioutil"
	"log"
	"os"
	"path"
	"testing"
	"time"
)

func TestTerraformDefaults(t *testing.T) {
	t.Parallel()

	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "examples/defaults")

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)
		terraform.Destroy(t, terraformOptions)

		keyPair := test_structure.LoadEc2KeyPair(t, exampleFolder)
		aws.DeleteEC2KeyPair(t, keyPair)
	})

	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions, keyPair := configureTerraformOptions(t, exampleFolder)
		test_structure.SaveTerraformOptions(t, exampleFolder, terraformOptions)
		test_structure.SaveEc2KeyPair(t, exampleFolder, keyPair)

		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "validate", func() {
		validateAirflowGet(t, exampleFolder)
	})
}

func validateAirflowGet(t *testing.T, exampleFolder string) {
	terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)

	instanceIp := terraform.Output(t, terraformOptions, "public_ip")
	url := "http://" + instanceIp + ":8080/health"

	tlsConfig := tls.Config{}
	maxRetries := 60
	timeBetweenRetries := 5 * time.Second

	time.Sleep(120 * time.Second)

	_, err := retry.DoWithRetryE(t, fmt.Sprintf("HTTP GET to URL %s", url), maxRetries, timeBetweenRetries, func() (string, error) {
		statusCode, _, err := http_helper.HttpGetE(t, url, &tlsConfig)
		assert.Equal(t, statusCode, 200, "Ok status code")
		return "", err
	})

	if err != nil {
		t.Fatal(err)
	}
}


func configureTerraformOptions(t *testing.T, exampleFolder string) (*terraform.Options, *aws.Ec2Keypair) {
	uniqueID := random.UniqueId()
	awsRegion := "us-east-1"

	keyPairName := fmt.Sprintf("terratest-ssh-example-%s", uniqueID)
	keyPair := aws.CreateAndImportEC2KeyPair(t, awsRegion, keyPairName)

	privateKeyPath := path.Join(exampleFolder, "id_rsa_test")
	publicKeyPath := path.Join(exampleFolder, "id_rsa_test.pub")

	err := ioutil.WriteFile(privateKeyPath, []byte(keyPair.PrivateKey), 0644)
	if err != nil {
		panic(err)
	}

	err = os.Chmod(privateKeyPath, 0600)
	if err != nil {
		log.Println(err)
	}

	err = ioutil.WriteFile(publicKeyPath, []byte(keyPair.PublicKey), 0644)
	if err != nil {
		panic(err)
	}

	terraformOptions := &terraform.Options{
		TerraformDir: exampleFolder,
		OutputMaxLineSize: 1024 * 1024,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"aws_region":    awsRegion,
			"public_key_path":    publicKeyPath,
			"private_key_path":   privateKeyPath,
		},
	}

	return terraformOptions, keyPair
}