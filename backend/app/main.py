```python
from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session

from app.database import Base, engine, get_db
from app.models.user import User
from app.schemas.user import UserCreate
from app.security import hash_password

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="SkillForge Backend",
    version="1.0.0"
)


@app.get("/")
def root():
    return {
        "message": "SkillForge Backend is running"
    }


@app.get("/health")
def health():
    return {
        "status": "ok"
    }


@app.post("/register")
def register_user(
    user: UserCreate,
    db: Session = Depends(get_db)
):

    new_user = User(
        name=user.name,
        email=user.email,
        password=hash_password(user.password),
        role=user.role
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return {
        "message": "User registered successfully",
        "user_id": new_user.id
    }
```
