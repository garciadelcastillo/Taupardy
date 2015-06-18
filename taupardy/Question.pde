public class Question {
  Category category;
  int value;
  String valueStr;
  String question, answer;
  int charsQ, charsA;
  boolean isDouble, 
  available, // never asked before?
  highlighted, // currently being shown?
  showAnswer;  // show question or answer?

  float baseX, baseY;
  float x, y;
  float w, h;
  float scale;

  Question(Category category_, int value_, String question_, String answer_, boolean isDouble_) {
    category = category_;
    value = value_;
    question = question_;
    answer = answer_;
    isDouble = isDouble_;

    highlighted = false;
    available = true;
    valueStr = "$" + value;

    category.add(this);
    computeStuff();
  }

  public void draw() {
    pushStyle();
    pushMatrix();

    translate(x, y);
    scale(scale);

    fill(BLUE_DARK);
    if (USE_BG_IMAGE) image(bg, 0, 0, w, h);
    else rect(0, 0, w, h);
    if (available) {
      if (highlighted) {
        fill(WHITE);
        textFont(questionFont);
        textLeading(1.1f * fontS);
        String txt = showAnswer ? answer : question;
        int chars = showAnswer ? charsA : charsQ;
        float widthtxt = chars > LONG_TXT ? 2 * w / 3 : w / 2;
        float heighttxt = chars > XLONG_TXT ? 2 * h / 3 : h / 2;
        textShadow(txt, 0, -vAlignS, widthtxt, heighttxt, BLACK, shadowDistS);
      } else {
        fill(ORANGE);
        textFont(valueFont);
        textShadow(valueStr, 0, -vAlignL, w, h, BLACK, shadowDist);
      }
    }

    popMatrix();
    popStyle();
  }

  public void display() {      
    float targetScale = screenW / w;
    Ani.to(this, 1.0f, "x", width / 2);
    Ani.to(this, 1.0f, "y", height / 2);
    Ani.to(this, 1.0f, "scale", targetScale);

    highlighted = true;
  }

  public void disable() {
    Ani.to(this, 0.3f, "x", baseX);
    Ani.to(this, 0.3f, "y", baseY);
    Ani.to(this, 1.0f, "scale", 1, Ani.EXPO_OUT, "onEnd:flushCurrentQuestion");

    highlighted = false;
    available = false;
  }

  public void flushCurrentQuestion() {
    currentQuestion = null;
  }

  void transitionTo(float ypos, float delay_) {
    Ani.to(this, 1.0f, delay_, "y", ypos);
  }

  public void transitionToBasePosition(float delay_) {
    Ani.to(this, 0.5f, delay_, "y", baseY);
  }

  private void computeStuff() {
    int index = this.category.questions.size();  // +1 for the category header
    baseX = category.baseX;
    baseY = index * cellH + cellH / 2;
    x = baseX;
    //      y = baseY;
    y = 1.2f * screenH;
    w = boxW;
    h = boxH;
    scale = 1;
    charsQ = question.length();
    charsA = answer.length();
  }

  public boolean isInside(float X, float Y) {
    return X >= x - w / 2 && X <= x + w / 2
      && Y >= y - h / 2 && Y <= y + h / 2;
  }

  public String toString() {
    return valueStr + "\n Q: " + question + (isDouble ? " [DOUBLE]" : "") + "\n A: " + answer;
  }
}

