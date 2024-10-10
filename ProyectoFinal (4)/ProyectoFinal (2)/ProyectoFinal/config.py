import os

class Config:
    SECRET_KEY = os.urandom(24)
    DEBUG = True
    SQLALCHEMY_DATABASE_URI = 'postgresql://postgres:Mafe111703@localhost:5432/XERO'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
