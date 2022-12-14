
let n = 1;
let len = 20;
let angle = 25.7;
let lsystem = new LSystem({
    axiom: 'F',
})

lsystem.setProduction('F', {
    successors: [
        { weight: 33, successor: 'F[+F]F[-F]F' }, // 33% probability
        { weight: 33, successor: 'F[+F]F' },// 33% probability
        { weight: 34, successor: 'F[-F]F' }// 34% probability
    ]
})


var sentence = lsystem.getString();

function generate() {
    len *= 0.8;
    lsystem.iterate(n);
    sentence = lsystem.getString();
    createP(sentence);
    turtle();
    console.log(sentence);
}


function turtle() {
    background(51);
    resetMatrix();
    translate(width / 2, height);
    stroke(255, 100);
    for (var i = 0; i < sentence.length; i++) {
        var current = sentence.charAt(i);

        if (current == "F") {
            line(0, 0, 0, -len);
            translate(0, -len);
        } else if (current == "+") {
            rotate(angle);
        } else if (current == "-") {
            rotate(-angle)
        } else if (current == "[") {
            push();
        } else if (current == "]") {
            pop();
        }
    }
    //limit -= 1;
}

function setup() {
    createCanvas(400, 400);
    background(51);
    createP(sentence);
    turtle();
    var button = createButton("generate");
    button.mousePressed(generate);
}