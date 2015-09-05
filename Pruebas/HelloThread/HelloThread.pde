  
String time = "";
String time2 = "";

void setup() {
  size(100, 100);
}

void draw() {
  background(0);
  // Every 30 frames request new data
  if (frameCount % 30 == 0) {
    thread("requestData");
    thread("requestData2");
  }
  text(time, 5, 50);
  text(time2, 0, 60);
}

// This happens as a separate thread and can take as long as it wants
void requestData() {
  JSONObject json = loadJSONObject("http://time.jsontest.com/");
  time = json.getString("time");
}

void requestData2() {
  JSONObject json = loadJSONObject("http://time.jsontest.com/");
  time2 = json.getString("time");
}

