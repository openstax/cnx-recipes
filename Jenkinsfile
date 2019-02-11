@Library('pipeline-library') _

pipeline {
  agent { label 'docker' }
  stages {
    stage('Publish Release') {
      when { buildingTag() }
      environment {
        TWINE_CREDS = credentials('pypi-openstax-creds')
        TWINE_USERNAME = "${TWINE_CREDS_USR}"
        TWINE_PASSWORD = "${TWINE_CREDS_PSW}"
      }
      steps {
        // Install git, run the python build, upload to pypi, and cleanup
        sh "docker run --rm -e TWINE_USERNAME -e TWINE_PASSWORD -v ${WORKSPACE}:/src:rw --workdir /src python:2-slim /bin/bash -c \"apt-get update && apt-get install -y git && pip install -q twine && python setup.py bdist_wheel && twine upload dist/* && rm -rf dist build *.egg-info versioneer.pyc\""
      }
    }
  }
}
