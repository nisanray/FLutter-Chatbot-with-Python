# Flutter Chatbot with Python

This application provides a chatbot that can respond to user queries, fetch real-time weather data, and collect user information. Users can either integrate the provided API into their own applications or websites, or use the provided Flutter application for the UI.

## Features

- **Chatbot Interaction**:
    - Communicate with a chatbot that connects to a Flask backend.
    - The chatbot can handle various user queries and provide appropriate responses.
    - It uses a trained neural network model to understand and respond to user inputs.

- **User Information Collection**:
    - Collect and store user information such as name, address, and phone number in Firestore.
    - The chatbot can prompt users to provide their information and store it securely.
    - This feature can be used to personalize user interactions and store user preferences.

- **Weather Data Retrieval**:
    - Fetch real-time weather data from Firestore for a specified location.
    - Users can ask the chatbot for weather updates by specifying a location.
    - The application retrieves the latest weather data and provides it to the user.

- **Time and Date Information**:
    - Provide current time and date information upon request.
    - Users can ask the chatbot for the current time or date.
    - The application fetches the current time and date and displays it to the user.

- **List App Users**:
    - Retrieve and display a list of app users stored in Firestore.
    - The application can list all users who have interacted with the chatbot.
    - This feature can be used for administrative purposes or to analyze user interactions.

## Requirements

- Flutter 2.0+
- Dart 2.12+
- Flask
- Firebase Admin SDK
- PyTorch
- NumPy
- Python 3.7+

## Setup

### Backend (Python)

1. **Clone the repository**:
    ```sh
    git clone https://github.com/nisanray/AI_ChatBot_Model_Python
    cd AI_ChatBot_Model_Python
    ```

2. **Create a virtual environment**:
    ```sh
    python -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
    ```

3. **Install dependencies**:
    ```sh
    pip install -r requirements.txt
    ```

4. **Set up Firebase**:
    - Download your Firebase service account key and save it as `serviceAccountKey.json` in the project root directory.
    - Ensure your Firestore database is set up with the required collections (`weather_updates`, `app_users`).

5. **Train the model**:
    - Run the `train.py` script to train the neural network model and generate `model.pth`:
    ```sh
    python train.py
    ```

6. **Prepare model and data files**:
    - Ensure `model.pth`, `intents.json`, and `train_data.json` are in the project root directory.

7. **Start the Flask server**:
    ```sh
    python app.py
    ```

### Frontend (Flutter)

1. **Clone the repository**:
    ```sh
    git clone https://github.com/nisanray/FLutter-Chatbot-with-Python.git
    cd FLutter-Chatbot-with-Python
    ```

2. **Install dependencies**:
    ```sh
    flutter pub get
    ```

3. **Update the API endpoint**:
    - Open the Flutter project and update the API endpoint in the code to point to your Flask server (e.g., `http://127.0.0.1:5000/`).

4. **Run the Flutter app**:
    ```sh
    flutter run
    ```

## API Endpoints

- **Chatbot Response**: `/chatbot` (POST)
    - Request:
        ```json
        {
            "message": "your message here",
            "user_id": "optional user id"
        }
        ```
    - Response:
        ```json
        {
            "response": "chatbot response here"
        }
        ```

- **List Users**: `/users` (GET)
    - Response:
        ```json
        {
            "users": [
                {
                    "user_id": "user id",
                    "name": "user name",
                    "address": "user address",
                    "phone": "user phone",
                    "timestamp": "timestamp"
                },
               "..."
            ]
        }
        ```

## Firebase Service Account Key

You can find the Firebase service account key by following these steps:

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Select your project.
3. Click on the gear icon next to "Project Overview" and select "Project settings".
4. Navigate to the "Service accounts" tab.
5. Click on "Generate new private key".
6. A JSON file containing your service account key will be downloaded. Save this file as `serviceAccountKey.json` in the root directory of your project.

Make sure to keep this file secure and do not share it publicly.

## Specific Formats for User Queries

To get specific responses from the chatbot, use the following formats:

- **Storing User Information**:
    - Start the process by sending: `"store my info"`
    - Follow the prompts to provide your name, address, and phone number.
    - Confirm by replying `"yes"` store your info.

- **Fetching Weather Data**:
    - Send a message in the format: `"weather in [location]"` (e.g., `"weather in New York"`).

- **Getting Current Time**:
    - Send a message containing any of the following keywords: `"time"`, `"current time"`, `"what is the time"`, `"tell me the time"`.

- **Getting Current Date**:
    - Send a message containing any of the following keywords: `"date"`, `"current date"`, `"what is the date"`, `"tell me the date"`, `"day"`.

## License

This project is licensed under the Nisan. See the `LICENSE` file for more details.
