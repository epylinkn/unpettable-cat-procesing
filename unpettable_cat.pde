import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

float t = 0;
float dt;
boolean sending = false;
float predict_x;
float predict_y;

void setup() {
  size(1600, 1000);
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 13000);
  predict_x = width / 2;
  predict_y = height / 2;
}

// send data
void sendOsc() {
  OscMessage myMessage = new OscMessage("/wek/inputs");
  myMessage.add(float(mouseX));
  myMessage.add(float(mouseY));
  oscP5.send(myMessage, myRemoteLocation);
}

void draw() {
  background(0);

  //float x = noise(t) * width;
  //float y = noise(t+5) * height;
  float r = noise(t+10)*255;
  float g = noise(t+15)*255;
  float b = noise(t+20)*255;

  fill(r, g, b);
  ellipse(predict_x, predict_y, 50, 50);

  t = t + 0.01;

  if (sending){
    sendOsc();
    fill(255, 0, 0);
    ellipse(10, 10, 10, 10);
  } else {
    fill(0, 255, 0);
    ellipse(10, 10, 10, 10);
  }
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());

  float x = theOscMessage.get(0).floatValue();
  predict_x = map(x, 0, 1, 0, width);

  float y = theOscMessage.get(1).floatValue();
  predict_y = map(y, 0, 1, 0, height);
}

void keyPressed() {
  if (key == ' '){
    sending = !sending;
  }
}
