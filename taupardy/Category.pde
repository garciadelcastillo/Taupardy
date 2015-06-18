public class Category {
  Panel panel;
  String title;
  ArrayList<Question> questions;
  float baseX, baseY;
  float x, y;
  int w, h;
  float scale;

  Category(Panel panel_, String title_, float xpos, float ypos, int width_, int height_) {
    panel = panel_;
    title = title_;
    baseX = xpos;
    baseY = ypos;
    w = width_;
    h = height_;

    // initial offset positions
    x = screenW / 2;
    y = 1.75f * screenH;

    scale = screenW / w;

    questions = new ArrayList<Question>();
  }

  void draw() {
    pushStyle();
    pushMatrix();

    translate(x, y);
    scale(scale);

    fill(BLUE_DARK);
    if (USE_BG_IMAGE) image(bg, 0, 0, w, h);
    else rect(0, 0, w, h);      
    fill(WHITE);
    textFont(categoryFont);
    textShadow(title, 0, -vAlignM, w, h, BLACK, shadowDist);

    popMatrix();
    popStyle();

    for (Question q : questions) 
      if (!q.highlighted)  // gets drawn behind following questions, will be drawn on the main loop 
        q.draw();
  }

  void add(Question quest) {
    questions.add(quest);
  }

  void transitionTo(float ypos, float delay_) {
    Ani.to(this, 1.0f, delay_, "y", ypos);
  }

  void transitionToBasePosition(float delay_) {
    Ani.to(this, 1.0f, delay_, "y", screenH / 2, Ani.EXPO_OUT, "onEnd:moveToBase");
  }

  private void moveToBase() {
    Ani.to(this, 1.5f, 1.0f, "y", baseY);
    Ani.to(this, 1.5f, 1.0f, "x", baseX);
    Ani.to(this, 1.5f, 1.0f, "scale", 1);
  }

  Question clicked() {
    for (int len = questions.size (), i = 0; i < len; i++) {
      Question q = questions.get(i);
      if (q.isInside(mouseX, mouseY) && q.available) return q;
    }
    return null;
  }

  public String toString() {
    return title.toUpperCase() + "\n" + questions + "\n";
  }
}
