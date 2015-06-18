/**********************************************************************
 * Taupardy! 
 * A Jeopardy! inspired Tau Day quiz game
 * https://github.com/garciadelcastillo/Taupardy
 * 
 * Enjoy, and share pictures with us! We surely did!
 * Oh, and if you create a cool panel, pull it to the repo ;)
 * http://fathom.info/latest/7850
 * 
 * Released under the GNU General Public License v2
 * (c) 2014-2015 Fathom Information Design and Jose Luis García del Castillo
 * http://www.fathom.info 
 * http://www.garciadelcastillo.es
 *********************************************************************/
 

// Taupardy! depends on Benedikt Groß's library for animations Ani:
// http://www.looksgood.de/libraries/Ani/
import de.looksgood.ani.*;

// Specify which panel file will you be using
String panelFileName = "panel_2015.csv";


public static final boolean FULLSCREEN = true, 
    USE_BG_IMAGE = false;
public static final int CATEGORY_COUNT = 6, 
    QUESTIONS_PER_CATEGORY = 5, 
    LONG_TXT = 80, // threshold in characters to trigger bigger text areas / smaller fonts
    XLONG_TXT = 110;
public static final float CELL_MARGIN = 0.035f, // relative width of the cell margin
    SHADOW_DROP = 0.003f;  // measured relative to displayheight

public static int 
    WHITE = scolor(255), 
    ORANGE = scolor(219, 160, 107), 
    BLUE_DARK = scolor(31, 39, 155), 
    BLUE_MEDIUM = scolor(26, 41, 141), 
    BLACK = scolor(0);


Panel panel;
PImage bg, splashBG;
PFont splashFont, categoryFont, valueFont, questionFont, scoreFont, endFont;

int questionCount;
int screenW, screenH;
float cellW, cellH; 
int boxW, boxH;
float shadowDist; 
int shadowDistS;
int fontS, fontM, fontL, fontXL, fontXXL;
float vAlignS, vAlignM, vAlignL, vAlignXL, vAlignXXL;  // a correction for central vertical alignment

boolean showSplash = true, 
    gameOver = false;
float splashY;

boolean onQuestion;  // is a question being displayed?
Question currentQuestion;

int score;
float scoreX, scoreY;

float endX, endY;

public void setup() {
  if (FULLSCREEN) {
    screenW = displayWidth;
    screenH = displayHeight;
  } else {
    screenW = 1024;
    screenH = 768;
  }

  size(screenW, screenH);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  noStroke();

  cellW = (float) (screenW) / CATEGORY_COUNT;
  cellH = (float) (screenH) / (QUESTIONS_PER_CATEGORY + 1);
  boxW = (int) (cellW - 2 * CELL_MARGIN * cellW);
  boxH = (int) (cellH - 2 * CELL_MARGIN * cellH);
  scoreX = screenW / 2;
  scoreY = 1.2f * screenH;
  endX = screenW / 2;
  endY = 2.0f * screenH;
  shadowDist = SHADOW_DROP * screenH;
  shadowDistS = 1;
  splashY = screenH / 2;

  questionCount = CATEGORY_COUNT * QUESTIONS_PER_CATEGORY;

  fontS = (int) (screenH / 90.0f);
  fontM = (int) (screenH / 22.5f);
  fontL = (int) (screenH / 9.0f);
  fontXL = (int) (screenH / 6.0f);
  fontXXL = (int) (screenH / 3.0f);
  vAlignS = (int) (0.1f * fontS);
  vAlignM = (int) (0.1f * fontM);
  vAlignL = (int) (0.1f * fontL);
  vAlignXL = (int) (0.1f * fontXL);
  vAlignXXL = (int) (0.1f * fontXXL);

  categoryFont = createFont("Swiss911.ttf", fontM);
  valueFont = createFont("Swiss911.ttf", fontL);
  questionFont = createFont("Korinna_Bold.ttf", fontS);
  scoreFont = createFont("Swiss911.ttf", fontXL);
  splashFont = createFont("URWAnnual.ttf", fontXXL);
  endFont = createFont("URWAnnual.ttf", fontXL);

  bg = loadImage("bluebg.png");
  splashBG = loadImage("splashbg.jpg");

  panel = new Panel("Taupardy!", panelFileName);

  Ani.init(this);
}

public void draw() {
  background(BLACK);

  panel.draw();

  if (currentQuestion != null) currentQuestion.draw();

  drawScore();

  if (showSplash) {
    showSplashScreen();
    //      return;
  }

  if (gameOver) drawEnd();
}

public void showSplashScreen() {
  pushStyle();
  pushMatrix();

  translate(width / 2, splashY);

  //    fill(BLUE_DARK);
  image(splashBG, 0, 0, width, height);
  //    rect(0, 0, screenW, screenH);
  textFont(splashFont);
  fill(WHITE);
  textShadow("TAUPARDY!", 0, 0, width, height, ORANGE, shadowDist);

  popMatrix();
  popStyle();
}

public void drawScore() {
  pushStyle();

  textFont(scoreFont);
  fill(255);
  textShadow("$" + score, scoreX, scoreY, screenW, screenW, BLACK, shadowDist);      

  popStyle();
}


public void startGameTransition() {
  Ani.to(this, 2.0f, "splashY", -0.75f * screenH, Ani.EXPO_OUT, "onEnd:disableSplash");

  float DURATION = 3;
  float QDELAY = 0.2f;
  float questionsDelay = CATEGORY_COUNT * DURATION;
  for (int i = 0; i < CATEGORY_COUNT; i++) {
    Category cat = panel.categories.get(i);
    cat.transitionToBasePosition(DURATION / 2 + DURATION * i);
    for (int j = 0; j < QUESTIONS_PER_CATEGORY; j++) {
      Question q = cat.questions.get(j);
      q.transitionToBasePosition(questionsDelay + DURATION + QDELAY * i + QDELAY * j);
    }
  }
}

public void displayScore(int addedAmount) {
  Ani.to(this, 1.0f, "score", score + addedAmount);
  Ani.to(this, 1.0f, "scoreY", 0.8f * screenH, Ani.EXPO_OUT, "onEnd:scoreDown");
}

public void scoreDown() {
  Ani.to(this, 1.0f, 1.0f, "scoreY", 1.2f * screenH);
}

private void disableSplash() {
  showSplash = false;
}

public boolean isGameOver() {
  boolean ended = true;
  for (int i = 0; i < CATEGORY_COUNT; i++) {
    Category cat = panel.categories.get(i);
    for (int j = 0; j < QUESTIONS_PER_CATEGORY; j++) {
      if (cat.questions.get(j).available) {
        ended = false;
        break;
      }
    }
    if (!ended) break;
  }

  return ended;
}



public void gameOver() {
  gameOver = true;

  float XDELAY = 0.5f;
  float YDELAY = 0.15f;
  for (int i = 0; i < CATEGORY_COUNT; i++) {
    Category cat = panel.categories.get(i);
    cat.transitionTo(-0.5f * screenH, XDELAY * i);
    for (int j = 0; j < QUESTIONS_PER_CATEGORY; j++) {
      Question q = cat.questions.get(j);
      q.transitionTo(-0.5f * screenH, XDELAY * i + YDELAY * j);
    }
  }

  displayEnd(XDELAY * CATEGORY_COUNT + YDELAY * QUESTIONS_PER_CATEGORY);
}

public void drawEnd() {
  pushStyle();

  textFont(endFont);
  fill(255);
  textShadow("$" + score + "\n\nCONGRATAU-LATIONS!", endX, endY - vAlignXL, screenW, screenW, ORANGE, shadowDist);      

  popStyle();
}

public void displayEnd(float delay_) {
  Ani.to(this, 3.0f, delay_, "endY", 0.5f * screenH, Ani.EXPO_OUT, "onEnd:displayEndOut");
}

public void displayEndOut() {
  Ani.to(this, 5.0f, 10.0f, "endY", 2.0f * screenH);
}




public void mouseClicked() {
  if (showSplash) {
    startGameTransition();
    return;
  }

  if (currentQuestion == null)  // only do if no question is highlighted 
    panel.clicked();
}

public void keyPressed() {
  if (showSplash) startGameTransition();

  if (key == 'y' || key == 'Y') {
    answerWasCorrect();
  }
  if (key == 'n' || key == 'N') {
    answerWasWrong();
  }
  if (key == 'a' || key == 'a') {
    displayAnswer();
  }
  if (key == 'q' || key == 'q') {
    displayQuestion();
  }
  if (key == 'x' || key == 'X') {
    gameOver();
  }
}

public void answerWasCorrect() {
  if (currentQuestion == null) return;
  displayScore(currentQuestion.value);
  currentQuestion.disable();
  if (isGameOver()) gameOver();
}

public void answerWasWrong() {
  if (currentQuestion == null) return;
  currentQuestion.disable();
  if (isGameOver()) gameOver();
}

public void displayAnswer() {
  if (currentQuestion == null) return;
  currentQuestion.showAnswer = true;
}

public void displayQuestion() {
  if (currentQuestion == null) return;
  currentQuestion.showAnswer = false;
}




public void textShadow(String text, float xpos, float ypos, float w, float h, int shadowColor, float d) {
  pushStyle();
  fill(shadowColor);
  text(text, xpos + d, ypos + d, w, h);
  popStyle();
  text(text, xpos, ypos, w, h);
}





public static int scolor(int gray) {
  return 0xFF000000 | (gray << 16) | (gray << 8) | gray;
}
public static int scolor(int gray, int alpha) {
  return 0x00000000 | (alpha << 24) | (gray << 16) | (gray << 8) | gray;
}
public static int scolor(int r, int g, int b) {
  return 0xFF000000 | (r << 16) | (g << 8) | b;
}
public static int scolor(int r, int g, int b, int alpha) {
  return 0x00000000 | (alpha << 24) | (r << 16) | (g << 8) | b;
}

public boolean sketchFullScreen() {
  return FULLSCREEN;
}

