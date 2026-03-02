pipeline {
  agent any
  options { timestamps() }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('System Info') {
      steps {
        bat 'echo Running on Windows & ver'
        bat 'echo Current directory: & cd'
      }
    }

    stage('Run Build Script') {
      steps {
        bat """
          echo Starting Windows build...
          call build.bat
        """
      }
    }

    stage('End') {
      steps {
        echo "Pipeline completed successfully!"
      }
    }
  }
}
