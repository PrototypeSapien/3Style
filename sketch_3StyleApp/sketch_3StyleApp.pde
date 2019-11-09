import controlP5.*;
ControlP5 cp5;
Button start;
ScrollableList pickSet;
String userInput;


Table cornerAlgs;
int numOfCornerAlgs;
TableRow pRow;

int mode;

void setup() {
  size(600, 600);
  background(255);
  textSize(50);

  mode = 0;

  cornerAlgs = loadTable("CornerComms.csv", "header");
  numOfCornerAlgs = cornerAlgs.getRowCount();
  pRow = cornerAlgs.getRow((int)random(0, numOfCornerAlgs));

  cp5 = new ControlP5(this);
  start = cp5.addButton("Random")
    .setPosition(400, 525)
    .setSize(175, 50)
    .setFont(createFont("Arial", 25))
    .onClick(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      int n = (int)pickSet.getValue();
      if (n == 0) {
        pRow = cornerAlgs.getRow((int)random(0, numOfCornerAlgs));
      } else {
        pRow = cornerAlgs.getRow((int)random(18*(n-1), 18*n));
      }
    }
  }
  );

  String sets[] = {"All", "A", "B", "D", "E", "G", "H", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X"}; 
  pickSet = cp5.addScrollableList("Pick Set")
    .setPosition(10, 10)
    .setSize(100, 150)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(sets)
    .setOpen(false);

  cp5.addTextfield("EnterText")
    .setPosition(25, height-75)
    .setSize(125, 50)
    .setAutoClear(true)
    .setFont(createFont("Arial", 25));

  cp5.addBang("Search")
    .setPosition(150, height-75)
    .setSize(50, 50);
}

void draw() {
  background(255);

  textAlign(CENTER);
  fill(0);

  textSize(100);
  text("Pair: " + pRow.getString("LetterPair"), 300, 200);
  textSize(50);
  text(pRow.getString("Algorithm"), 300, 400);
}

void Search() {
  userInput = cp5.get(Textfield.class, "EnterText").getText().toUpperCase();
  TableRow tempRow = pRow;

  try {
    pRow = cornerAlgs.findRow(userInput, "LetterPair");
    pRow.getString("LetterPair");
  } 
  catch(NullPointerException e) {
    println("Enter in a valid letter pair.");
    pRow = tempRow;
  }
  
  cp5.get(Textfield.class, "EnterText").clear();
}



void keyPressed() {
  switch(key) {
    case(' '):
      int n = (int)pickSet.getValue();
      if (n == 0) {
        pRow = cornerAlgs.getRow((int)random(0, numOfCornerAlgs));
      } else {
        pRow = cornerAlgs.getRow((int)random(18*(n-1), 18*n));
      }
      break;
    case(ENTER):
      Search();
      break;
    default:
      if(!cp5.get(Textfield.class, "EnterText").isActive()) {
        cp5.get(Textfield.class, "EnterText").setText(cp5.get(Textfield.class, "EnterText").getText() + key);
      }
      break;
  }
}

String getSetup(String alg) {
  String setup = "";
  for (int i = 0; i < alg.length(); i++) {
    if (alg.charAt(i) == ':') {
      setup = alg.substring(1, i);
      return setup;
    }
  }
  return setup;
}

String getReverseAlgString(String alg) {
  int slice1 = 0, slice2 = 0, slice3 = 0, slice4 = 0;


  for (int i = 0; i < alg.length(); i++) {
    if (alg.charAt(i) == ':') {
      slice1 = i+3;
    }
    if (alg.charAt(i) == ',') {
      slice2 = i;
      slice3 = i+2;
    }
    if (alg.charAt(i) == ']') {
      slice4 = i;
      break;
    }
  }

  String p1 = alg.substring(slice1, slice2);
  String p2 = alg.substring(slice3, slice4);

  return (alg.substring(0, slice1) + p2 + alg.substring(slice2, slice3) + p1 + alg.substring(slice4, alg.length()));
}

void printTable(Table table) {
  for (TableRow row : table.rows()) {
    println(row.getString("LetterPair") + row.getString("Algorithm"));
  }
}


// addReverseAlgs was a one time use function to add the reverse of each function.
/*void addReverseAlgs(Table table) {
 String letterPair;
 String alg;
 int rowCount = table.getRowCount();
 for (int i = 0; i < rowCount; i++) {
 TableRow row = table.getRow(i);
 
 // You can access the fields via their column name (or index)
 letterPair = row.getString("LetterPair");
 alg = row.getString("Algorithm");
 
 TableRow newRow = table.addRow();
 newRow.setString("LetterPair", letterPair.substring(1) + letterPair.substring(0, 1));
 newRow.setString("Algorithm", getReverseAlgString(alg));
 
 
 if(letterPair == "WX") {
 break;
 }
 // Writing the CSV back to the same file
 saveTable(table, "data/CornerComms.csv");
 
 }
 }*/
