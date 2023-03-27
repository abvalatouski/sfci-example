#!groovy

import groovy.json.JsonSlurperClassic

node {
  def SF_CONSUMER_KEY=env.SF_CONSUMER_KEY
  def SF_USERNAME=env.SF_USERNAME
  def SERVER_KEY_CREDENTALS_ID=env.SERVER_KEY_CREDENTALS_ID
  def TEST_LEVEL='RunLocalTests'
  def SF_INSTANCE_URL = env.SF_INSTANCE_URL ?: "https://login.salesforce.com"

  stage('checkout source') {
    checkout scm
  }

  withCredentials([file(credentialsId: SERVER_KEY_CREDENTALS_ID, variable: 'server_key_file')]) {
    stage('Authorize DevHub') {
      rc = command "sfdx auth:jwt:grant --instanceurl ${SF_INSTANCE_URL} --clientid ${SF_CONSUMER_KEY} --username ${SF_USERNAME} --jwtkeyfile ${server_key_file} --setdefaultdevhubusername --setalias HubOrg"
      if (rc != 0) {
        error 'Salesforce dev hub org authorization failed.'
      }
    }
  }
}

def command(script) {
  if (isUnix()) {
    return sh(returnStatus: true, script: script);
  } else {
    return bat(returnStatus: true, script: script);
  }
}
