const DEG_TO_RAD = Math.PI / 180;

//THREE js variables
const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1500);
const renderer = new THREE.WebGLRenderer({ antialias: true });
camera.translateY(200);
camera.lookAt(new THREE.Vector3(0, 0, 0));
const cachedMatrix4 = new THREE.Matrix4();
const cachedQuat = new THREE.Quaternion();

// The Tree
const tree = new THREE.Group();

// Trunk variables
const material = new THREE.LineBasicMaterial({ color: 0xB24E4B });
const geometry = new THREE.Geometry();

//L-Systems rules variables. TRY to change angles and use other rules. Or invent your own rules
const angle = 35;
const axiom = "F";
let sentence = axiom;
const len = 10;
const limit = 4;
const rules = [];
rules[0] = {
  // TRY new rules
  // a: "F",
  // b: "F[+F]F[-F]F"

  // a: "F",
  // b: "F[+F]F[-F][F]"

  a: "F",
  b: "FF+[+F-F-F]-[-F+F+F]"
}

// Let's go!
const init = () => {
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.setClearColor(0xFDFF9E, 1);
  document.body.style.margin = 0;
  document.body.appendChild(renderer.domElement);
  camera.position.z = 80;
  controls = new THREE.OrbitControls(camera, renderer.domElement);

  const light = new THREE.PointLight(0xffffff, 1, 0);
  light.position.set(100, 200, 0);
  scene.add(light);

  const light2 = new THREE.PointLight(0xffffff, 1, 100);
  light2.position.set(0, 100, -200);
  scene.add(light2);

  const directionalLight = new THREE.DirectionalLight(0xffffff);
  directionalLight.position.set(0, 0.5, -0.5);
  directionalLight.position.normalize();
  scene.add(directionalLight);

  // Have a look at the axis
  let axisHelper = new THREE.AxesHelper(50);
  scene.add(axisHelper);

  window.addEventListener('resize', function () {
    let WIDTH = window.innerWidth,
      HEIGHT = window.innerHeight;
    renderer.setSize(WIDTH, HEIGHT);
    camera.aspect = WIDTH / HEIGHT;
    camera.updateProjectionMatrix();
  });

  createTree();

  render();
};

const createTree = () => {
  const branches = [];
  const sentence = generate(rules);
  createBranchesFromSentence(sentence, branches, len);

  for (const b of branches) {
    addBranch(geometry, b.start.position, b.end.position);
  }

  const trunk = new THREE.LineSegments(geometry, material);
  tree.add(trunk);

  scene.add(tree);
}

const addBranch = (geom, v1, v2) => {
  geom.vertices.push(new THREE.Vector3(v1.x, v1.y, v1.z));
  geom.vertices.push(new THREE.Vector3(v2.x, v2.y, v2.z));
}

const generate = (rules) => {
  for (let l = 0; l < limit; l++) {
    let nextSentence = "";

    for (let i = 0; i < sentence.length; i++) {
      const current = sentence.charAt(i);
      let found = false;
      for (let j = 0; j < rules.length; j++) {
        if (current == rules[j].a) {
          found = true;
          nextSentence += rules[j].b;
          break;
        }
      }
      if (!found) {
        nextSentence += current;
      }
    }
    sentence = nextSentence;
  }
  return sentence;
}

const createBranchesFromSentence = (sentence, branches, len) => {
  const turtle = new THREE.Object3D();
  turtle.position.set(0, -200, 0);
  const bookmark = [];

  for (let i = 0; i < sentence.length; i++) {
    const current = sentence.charAt(i);

    let addBranch = false;
    if (current == "F") {
      addBranch = true;
    } else if (current == "+") {
      turtle.rotateZ(angle * DEG_TO_RAD);
    } else if (current == "-") {
      turtle.rotateZ(-angle * DEG_TO_RAD);
    } else if (current == "[") {
      bookmark.push(turtle.clone());
    } else if (current == "]") {
      turtle.copy(bookmark.pop(), false);
    }

    if (addBranch) {
      let end = turtle.clone().translateY(len);
      let branch = { "start": turtle.clone(), "end": end };
      turtle.copy(end);
      branches.push(branch);
    }
  }
}

const render = () => {
  renderer.render(scene, camera);
  requestAnimationFrame(render);
}

init();

