let iterations = 50000;
let radius = 1;
let scale = 100.0
let points = [];

function setup() {
    points[0] = createVector(0, 0);
    createCanvas(800, 800);
    for (let i = 0; i <= iterations; i++) {
        let coin = random(1.0);
        if (coin <= 0.33) {
            points.push(transformA(points[i], i));
        } else if (coin > 0.33 && coin <= 0.66) {
            points.push(transformB(points[i], i));
        } else {
            points.push(transformC(points[i], i));
        }
    }
    // check here how many points.
    console.log(points.length);
}

function draw() {
    translate(width / 2.0, height / 2.0)
    for (let p in points) {
        let point = points[p];
        stroke(255, 0, 0);
        noFill();
        circle(point.x * scale, point.y * scale, radius);
    }
    noLoop();
}

// Sierpinsky Triangle

function transformA(point, _i) {
    let x = point.x * 0.5;
    let y = point.y * 0.5;

    return createVector(x, y);
}

function transformB(point, _i) {
    let x = point.x * 0.5 + 0.5;
    let y = point.y * 0.5 + 0.5;

    return createVector(x, y);
}

function transformC(point, _i) {
    let x = point.x * 0.5 + 1.0;
    let y = point.y * 0.5;

    return createVector(x, y);
}
