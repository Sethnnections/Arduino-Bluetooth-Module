#include <SoftwareSerial.h>

SoftwareSerial bt(2, 3); // RX, TX

void setup() {
  Serial.begin(9600); // Serial monitor
  bt.begin(9600); // Bluetooth module
}

void loop() {
  // Send data over Bluetooth
  bt.println("Hello, Bluetooth!");

  // Check if data is available to read from Bluetooth
  if (bt.available()) {
    // Read data from Bluetooth and print it to serial monitor
    String receivedData = bt.readString();
    Serial.println("Received: " + receivedData);
  }

  delay(1000); // Delay for stability
}
