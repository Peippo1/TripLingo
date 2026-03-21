from pydantic import BaseModel, Field


class ItineraryRequest(BaseModel):
    destination: str
    prompt: str
    preferences: list[str] = Field(default_factory=list)
    saved_places: list[str] = Field(default_factory=list)


class ItineraryBlock(BaseModel):
    title: str
    activities: list[str]


class ItineraryResponse(BaseModel):
    destination: str
    morning: ItineraryBlock
    afternoon: ItineraryBlock
    evening: ItineraryBlock
    notes: list[str] = Field(default_factory=list)
