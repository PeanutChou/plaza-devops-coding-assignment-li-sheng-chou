import requests
import os
from fastapi import FastAPI, HTTPException
import asyncio

app = FastAPI()


@app.get("/")
def hello():
    # TODO: Replace the message below with the value of a configuration parameter
    # Get from deployment.yaml's ENV setting
    return {"message": os.environ['ROOT_MESSAGE']}

# Add query param
@app.get("/data/{id}")
def get_star_wars_data(id:int):
    try:
        # TODO: Replace the "1" in the URL below with the value of a query parameter
        response = requests.get(f"https://swapi.dev/api/people/{id}", timeout=5)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.HTTPError as e:
        raise HTTPException(status_code=500, detail="API Error")
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=503, detail="Service Unavailable")
    except (KeyError, ValueError) as e:
        raise HTTPException(status_code=500, detail="Data Processing Error")


# TODO: Add new endpoint to return the top 20 people in the Star Wars API with the highest BMI.
@app.get("/top-people-by-bmi")
def get_star_wars_data_by_bmi():
    try:
        # Better to use asyncio to async requests if can know the amount of pages
        result = []
        this_res = requests.get(f"https://swapi.dev/api/people", timeout=10).json()
        data = [*this_res["results"]]
        while True:
            this_res = requests.get(this_res["next"], timeout=10).json()
            data = [*data,*this_res["results"]]
            if this_res["next"] == None:
                break
        # there's seperator & "unknown" value in mass/height, remember to clean the data
        # more readable:
        for each in data:
            if each["mass"] != "unknown" and each["height"] != "unknown":
                each = {**each, "bmi":round(float(each["mass"].replace(",","")) / (float(each["height"].replace(",","")) / 100) ** 2, 2)}
                result = [*result, each]
        # lambda style
        # result = list(map(lambda obj: {**obj, "bmi": round(float(obj["mass"].replace(",","")) / (int(float["height"].replace(",","")) / 100) ** 2, 2)} if obj["mass"] != "unknown" and obj["height"] != "unknown" else obj, result))
        return sorted(result, key=lambda x: x["bmi"], reverse=True)[:20]
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=503, detail="Service Unavailable")
    except (KeyError, ValueError) as e:
        print(e)
        raise HTTPException(status_code=500, detail="Data Processing Error")
    
if __name__ == "__main__":
    import uvicorn
    
    uvicorn.run("app:app", host="0.0.0.0", port=8000)
