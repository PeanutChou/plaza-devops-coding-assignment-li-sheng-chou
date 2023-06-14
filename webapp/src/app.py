import requests
from fastapi import FastAPI, HTTPException

app = FastAPI()


@app.get("/")
def hello():
    # TODO: Replace the message below with the value of a configuration parameter
    return {"message": "Hello, World!"}


@app.get("/data")
def get_star_wars_data():
    try:
        # TODO: Replace the "1" in the URL below with the value of a query parameter
        response = requests.get("https://swapi.dev/api/people/1", timeout=5)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.HTTPError as e:
        raise HTTPException(status_code=500, detail="API Error")
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=503, detail="Service Unavailable")
    except (KeyError, ValueError) as e:
        raise HTTPException(status_code=500, detail="Data Processing Error")


# TODO: Add new endpoint to return the top 20 people in the Star Wars API with the highest BMI.


if __name__ == "__main__":
    import uvicorn
    
    uvicorn.run("app:app", host="0.0.0.0", port=8000)
