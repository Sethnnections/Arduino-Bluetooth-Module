#include <SoftwareSerial.h>
#include <DHT11.h>
#include <ArduinoJson.h> // Include the ArduinoJson library for JSON manipulation

SoftwareSerial bt(2, 3); // RX, TX
DHT11 dht11(5);

int prevTemperature = 0; // Previous temperature value
int prevHumidity = 0;    // Previous humidity value

void setup() {
  Serial.begin(9600); // Serial monitor
  bt.begin(9600); // Bluetooth module
}

void loop() {
  // Attempt to read the temperature value from the DHT11 sensor.
  int temperature = dht11.readTemperature();
  int humidity = dht11.readHumidity();

  // Create a JSON object to store temperature and humidity data
  StaticJsonDocument<100> jsonDoc; // Adjust the size based on your data
  
  // Check if the sensor reading is successful
  if (temperature != DHT11::ERROR_CHECKSUM && temperature != DHT11::ERROR_TIMEOUT) {
    // Store temperature and humidity data in the JSON object
    jsonDoc["T"] = temperature;
    jsonDoc["H"] = humidity;

    // Update previous values
    prevTemperature = temperature;
    prevHumidity = humidity;
  } else {
    // Use previous values if current reading fails
    jsonDoc["T"] = prevTemperature;
    jsonDoc["H"] = prevHumidity;
    
    // If there's an error, print the appropriate error message.
    bt.print("Temperature Error: ");
    bt.println(DHT11::getErrorString(temperature));
  }

  // Serialize the JSON object into a string
  String jsonString;
  serializeJson(jsonDoc, jsonString);

  // Send the JSON string over Bluetooth
  bt.println(jsonString);

  delay(1000); // Delay for stability
}

