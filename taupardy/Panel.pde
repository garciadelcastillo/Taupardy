public class Panel {
  String title;
  Table data;
  ArrayList<Category> categories;

  Panel(String title_, String filename) {
    title = title_;
    categories = new ArrayList<Category>();
    data = loadTable(filename, "header");
    loadData();
  }

  void draw() {
    for (Category cat : categories) cat.draw();
  }

  void clicked() {
    Question click = null; 
    for (int len = categories.size (), i = 0; i < len; i++) {
      Question c = categories.get(i).clicked();
      if (c != null) {
        click = c;
        break;
      }
    }
    if (click != null) {
      onQuestion = true;
      click.display();
      currentQuestion = click;
    }
  }

  void loadData() {
    for (TableRow row : data.rows ()) {
      String catTitle = row.getString("CATEGORY").toUpperCase();
      int val = row.getInt("VALUE");
      String q = row.getString("QUESTION").toUpperCase();
      String a = row.getString("ANSWER").toUpperCase();
      String doubStr = row.getString("IS_DOUBLE").toLowerCase();
      boolean doub = doubStr.equals("true");
      Category cat = findCategory(catTitle);
      Question question = new Question(cat, val, q, a, doub);
    }
  }

  Category findCategory(String title) {
    // search for it
    for (Category cat : categories) {
      if ( cat.title.toLowerCase().equals(title.toLowerCase()) ) {
        return cat;
      }
    }

    // if not found, create it, add it to list and return it
    int index = categories.size();
    Category newCat = new Category(this, title, 
    index * cellW + cellW / 2, cellH / 2, boxW, boxH);
    categories.add(newCat);
    return newCat;
  }

  public String toString() {
    return "PANEL " + title.toUpperCase() + ":\n" + categories;
  }
}
