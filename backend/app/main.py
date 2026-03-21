from fastapi import FastAPI

from app.routes.itinerary import router as itinerary_router


app = FastAPI(title="CityScout Backend", version="0.1.0")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


app.include_router(itinerary_router)
