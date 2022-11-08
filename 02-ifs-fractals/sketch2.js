let iterations = 20;
let points = [];

function setup() {
  points[0] = createVector(0, 0);
  createCanvas(800, 800);
  for (let i = 0; i <= iterations; i++) {
    points.push(transform(points[i], i));
  }
}

function draw() {
  for (let p in points) {
    let point = points[p];
    stroke(255, 0, 0);
    noFill();
    circle(point.x, point.y, 20);
  }
  noLoop();
}

// let's crate a function that takes care of the transformation
function transform(point, i) {
  let x = point.x + i * 2;
  let y = point.y + i * 2;
  return createVector(x, y);
}
