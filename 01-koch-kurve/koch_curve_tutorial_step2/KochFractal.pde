// Koch Curve
// A class to manage the list of line segments in the snowflake pattern

class KochFractal {
  PVector start;
  PVector end;
  ArrayList<KochLine> lines;
  int count;
  
  KochFractal() {
    start = new PVector(0,height-20);
    end = new PVector(width,height-20);
    lines = new ArrayList<KochLine>();
    restart();
  }

  void nextLevel() {  
    lines = iterate(lines);
    count++;
  }

  void restart() { 
    count = 0; 
    lines.clear();
    lines.add(new KochLine(start,end));
  }
  
  int getCount() {
    return count;
  }
  
  void render() {
    for(KochLine l : lines) {
      l.display();
    }
  }

  // This is where the **MAGIC** happens
  // Step 1: Create an empty arraylist
  // Step 2: For every line currently in the arraylist
  //   - calculate 4 line segments based on Koch algorithm
  //   - add all 4 line segments into the new arraylist
  // Step 3: Return the new arraylist and it becomes the list of line segments for the structure
  
  // As we do this over and over again, each line gets broken into 4 lines, which gets broken into 4 lines, and so on. . . 
  ArrayList iterate(ArrayList<KochLine> before) {
    ArrayList now = new ArrayList<KochLine>();
    for(KochLine l : before) {
      // Now let's rivist this part of the algorithm. Instead of drawing random lines, 
      // we draw lines starting from the the start and the end of the line l.
      // Look at the template of the koch curve, we divide a line in 3 parts, then we take the central part
      // we break it in 2 and we rotate the two parts.
      // In the result, we can identify 5 points, the beginning of the line, the left part of the spike, the right part of the spike
      // and the middle part of the spike.
      // let's add five methods to the line class, and then we will complete them
      PVector a = l.start();                 
      PVector b = l.kochleft();
      PVector c = l.kochmiddle();
      PVector d = l.kochright();
      PVector e = l.end();
      now.add(new KochLine(a,b));
      now.add(new KochLine(b,c));
      now.add(new KochLine(c,d));
      now.add(new KochLine(d,e));
    }
    return now;
  }

}
