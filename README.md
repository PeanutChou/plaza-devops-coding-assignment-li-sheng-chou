# Plaza DevOps Coding Assignment

This repository contains the code for setting up a GKE cluster using Terraform and a sample web application. Your task is to containerize the web application, create a Helm chart for deployment, and update the GitHub Actions workflow file for automated testing, building, and deploying the container image to the Kubernetes cluster.

## Repository Structure

- `infrastructure`: This directory contains the Terraform code for setting up the GKE cluster. This directory will not be modified in the tasks.
- `webapp`: This directory contains the source code for the web application and tests.
  - `src`: This directory contains the main Python file for the web application.
  - `tests`: This directory contains test cases for the web application.
- `helm-chart`: This directory will contain the Helm chart for deploying the web application. You'll need to create this as part of the assignment.
- `.github/workflows`: This directory contains the GitHub Actions workflow file that you'll need to update.

## Getting Started

### Prerequisites

- Python 3.x
- Docker
- Helm

### Web Application

The web application is a simple app that displays data from the Star Wars API. You can explore the API using `curl https://swapi.dev`.

To set up and run the web application, follow these steps:

```bash
# Navigate to the 'webapp' directory
cd webapp

# Create a Python virtual environment and activate it
python -m venv env
source env/bin/activate

# Install the necessary dependencies
pip install -r requirements.txt

# Start the application using Uvicorn
uvicorn src.app:app --reload
```

The application will be accessible at http://localhost:8000.

## Testing

To run the tests for the web application, use the following steps:

```bash
# Navigate to the 'webapp' directory
cd webapp

# Install the necessary dependencies
pip install -r requirements.txt

# Run the tests
pytest tests/
```

The tests will run and their results will be displayed in the terminal.

## Instructions for the Candidate

Your tasks are as follows:

1. Clone the repository.
2. **Dockerfile**: Create a Dockerfile in the `webapp` directory to containerize the web application. Ensure that the Dockerfile installs all necessary dependencies and starts the application when a container is run.

```bash
# In the 'webapp' directory
echo "FROM python:3.10" > Dockerfile
# Add the necessary statements to the Dockerfile in order to be able to build a working image.
```

3. **Add Features**:
   1. Currently, the `/` endpoint has a hard-coded message. Make this message configurable using a configuration parameter in the Helm values file.
   2. Currently, the `/data` endpoint is hard-coded to fetch the first entry in the `people` database. Get the ID from a query parameter instead of a hard-coded value.
   3. Add a new endpoint `top-people-by-bmi` that fetches all people from the Star Wars API and returns a list of the 20 people with the highest BMI, sorted by BMI. BMI is calculated as `mass / height^2`.

You might find the [FastAPI](https://fastapi.tiangolo.com/tutorial/) documentation useful here.

4. **Test Cases**: Enhance the existing test case in `webapp/tests/test_get_star_wars_data.py` (`test_get_star_wars_data`) by adding more test cases to cover different scenarios, error conditions, and edge cases. Write additional test cases for the new and updated endpoints.

```bash
# Example: Adding test cases in 'webapp/tests/test_get_star_wars_data.py'

def test_api_http_error():
    # Test case for API HTTP error. For example, fetch a Star Wars character with an ID that doesn't exist.
    pass
```

5. **Helm Chart**: Update the helm chart under the `helm-chart` directory to implement the data category. Add a Helm value such as `dataCategory` and make it available in the web application through some mechanism.

```bash
# In the 'helm-chart' directory
# Update the 'values.yaml' file and other necessary files in the chart
```

6. **Workflow**: Update the GitHub Actions workflow file in `.github/workflows` to automatically build the Docker image, push it to the container registry, and deploy the web application to the GKE cluster using the Helm chart.

```bash
# In the '.github/workflows' directory
# Update the workflow file with necessary steps and actions. We have added comments specifying suitable locations for such steps.
# The steps syntax to use will be the following:

  - name: Step description
    run: |
      shell command 1
      shell command 2
      shell command 3
      
# You can use environment variables defined earlier in the workflow just as you would use them in the shell.
```

7. During the assignment demonstration, you will be asked to push the code to a branch named `candidate-YOUR-NAME` of the original repository. You will be given write access during the presentation.
