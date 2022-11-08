let iterations = 50000;
let radius = 1;
// add a scale to see the fractal
let scale = 40;
let points = [];

function setup() {
    points[0] = createVector(0, 0);
    createCanvas(800, 800);
    for (let i = 0; i <= iterations; i++) {
        points.push(transform(points[i], i));
    }
}

function draw() {
    // translate the picture in the middle of the screen
    translate(width / 2.0, height / 2.0);
    for (let p in points) {
        let point = points[p];
        stroke(255, 0, 0);
        noFill();
        circle(point.x * scale, point.y * scale, radius);
    }
    noLoop();
}

// Barnsley fern

function transform(point, _i) {
    let p = random(1.0);
    let x;
    let y;

    if (p == 1.0) {
        x = (0);
        y = (0.16 * (point.y));
    }

    if (p >= 0.2 && p <= 0.86) {
        x = (0.85 * (point.x) + 0.04 * (point.y));
        y = (-0.04 * (point.x) + 0.85 * (point.y) + 1.6);
    }

    if (p >= 0.87 && p <= 0.93) {
        x = (0.2 * (point.x) - 0.26 * (point.y));
        y = (0.23 * (point.x) + 0.22 * (point.y) + 1.6);
    }


    if (p >= 0.94 && p <= 1.0) {
        x = (-0.15 * (point.x) + 0.28 * (point.y));
        y = (0.26 * (point.x) + 0.24 * (point.y) + 0.44);
    }

    return createVector(x, y);
}
