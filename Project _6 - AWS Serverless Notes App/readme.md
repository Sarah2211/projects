# AWS Serverless Notes App

A full-stack CRUD notes app built with AWS serverless services.

## Architecture
S3 (frontend hosting) → API Gateway → Lambda (Python) → DynamoDB

## Features
- Create, read, update, delete notes
- Serverless backend — no server management
- REST API with 4 endpoints

## API Endpoints
| Method | Route         | Lambda       |
|--------|---------------|--------------|
| GET    | /notes        | getNote      |
| POST   | /notes        | saveNote     |
| PUT    | /notes/{id}   | updateNote   |
| DELETE | /notes/{id}   | deleteNote   |

## Setup
1. Deploy each Lambda function in AWS
2. Create API Gateway with routes above
3. Set API_URL in script.js
4. Host frontend/ on S3 with static website hosting
