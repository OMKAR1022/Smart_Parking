#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// Replace with your network credentials
const char* ssid = "703";
const char* password = "703_boys";

// HiveMQ public broker details
const char* mqtt_server = "broker.hivemq.com";
const int mqtt_port = 1883;

WiFiClient espClient;
PubSubClient client(espClient);

// Replace with your unique client ID
const char* clientId = "nodeMCU_12345678_1";

// Pin for the built-in LED (GPIO2, D4)
const int ledPin = D4; // GPIO2 (D4) on NodeMCU

void setup() {
  Serial.begin(115200);
  pinMode(ledPin, OUTPUT); // Initialize the built-in LED pin as an output
  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);

  if (client.connect(clientId)) {
    Serial.println("Connected to MQTT broker");
    client.subscribe("Omkar_Smart_Parking"); // Subscribe to topic
  } else {
    Serial.print("Failed to connect, rc=");
    Serial.print(client.state());
    delay(2000);
  }
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
}

void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("Connected to WiFi");
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    if (client.connect(clientId)) {
      Serial.println("connected");
      client.subscribe("Omkar_Smart_Parking"); // Subscribe to topic
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      delay(5000);
    }
  }
}

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  
  String message = "";
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  Serial.println(message);

  // Check if the car is present in the database (For now, simulate it as available or not)
  // You should modify this to check if the car is available in your Firestore database or another data source.
  if (message == "CHECK_CAR") {
    bool isCarAvailable = checkCarAvailability(); // You need to implement this function to check the database

    if (isCarAvailable) {
      digitalWrite(ledPin, LOW); // Turn LED on (LOW to turn it on)
      Serial.println("Car found! LED ON.");
      delay(5000); // Wait for 5 seconds
      digitalWrite(ledPin, HIGH); // Turn LED off (HIGH to turn it off)
      Serial.println("LED OFF after 5 seconds.");
    } else {
      digitalWrite(ledPin, HIGH); // Turn LED off (HIGH to turn it off)
      Serial.println("Car not found! LED OFF.");
    }
  }
}

// Simulate the car availability check function (replace with your actual database check)
bool checkCarAvailability() {
  // For now, let's say the car is always available.
  // You should replace this logic with an actual Firestore query or database check.
  return true;  // Simulating car is available
}
