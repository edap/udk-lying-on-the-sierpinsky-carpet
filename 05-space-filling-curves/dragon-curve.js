// variation: with colors

let sys = ["|", "X"], scalee = 1

function setup() { createCanvas(500, 500) }

function keyPressed() {
    // the map function map X to "X+Y|+"
    // and Y to "-|X-Y"
    // the split function explodes the string in an array of array of chars
    sys = sys.map(c => ({ X: "X+Y|+", Y: "-|X-Y" }[c] || c).split(""));
    //console.log(sys);
    // the sys.flat function flatten the multidimensional array into o one dimensional array
    sys = sys.flat();
    console.log(sys);
    scalee *= 0.75
}

function draw() {
    translate(width / 2, height / 2)
    background(0, 0, 0)
    stroke(255)
    push()
    for (const char of sys) {
        if (char == "|") {
            line(0, 0, 0, - width / 8 * scalee)
            translate(0, - width / 8 * scalee)
        }
        if (char == "+") {
            rotate(PI / 2)
        } else if (char == "-") {
            rotate(-PI / 2);
        }
    }
    pop()
}