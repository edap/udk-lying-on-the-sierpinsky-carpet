/* always update version number here */
let iterations = 20;
let points = [];

function setup() {
  points[0] = createVector(0, 0);
  createCanvas(800, 800);
  for (let i = 0; i <= iterations; i++) {
    points.push(createVector(i, i));
  }
  console.log(points);

}

function draw() {
  for (let p in points) {
    let point = points[p];
    console.log(point.x);
    color(255, 0, 0);
    circle(point.x, point.y, 20);

  }
  noLoop();
}
