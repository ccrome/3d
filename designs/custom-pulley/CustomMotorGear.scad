// Generator for McMaster Carr MXL/XL Gear belts
// See http://www.mcmaster.com/#catalog/119/1056/ for parts this should represent

PI=3.141592657;

OD=in2mm(0.79);
bore=5; //in2mm(1/4);
boreFudge=0.3;
v=in2mm(0.611155);
gearID = v-1;
z=2+bore; // THickest I'm willing to make this for screw insertion.  Was: in2mm(0.442);
w=in2mm(0.16);
x=in2mm(0.26);
y=in2mm(0.516);

setscrewDepth=(z-bore)/2; //both z and bore are diameters;
setscrewR=1.5;
setscrewFudge=1;

//make this high res...
$fa=0.1;
$fs=0.1;

rotate([0,180,0]) {
	difference () {
		union () {
			//These cylinders make up the majority of the gear
			//center
			cylinder(r=z/2, h=y);
			translate([0,0,y-x]) {
				//center of where belt sits
				cylinder(r=gearID/2,h=x);
				// Gear bits
				translate([0,0,((x-w)/2)]) rotate([90,0,0]) pitch(in2mm(0.08), v/2, w, v/2 - gearID/2);
				//closer to origin pulley edge
				cylinder(r=OD/2,h=(x-w)/2);
				//further from origin pulley edge
				translate([0,0,w + ((x-w)/2)]) cylinder(r=OD/2,h=(x-w)/2);
				
				
			}
		}
		// Motor shaft bore
		cylinder (r=bore/2+boreFudge, h=y);
		
		// Setscrew 1
		rotate([90,0,0]) translate([0,(y-x)/2,bore/2-setscrewFudge]) #cylinder(r=setscrewR, h=setscrewDepth+setscrewFudge);
		rotate([0,90,0]) translate([-(y-x)/2,0,bore/2-setscrewFudge]) #cylinder(r=setscrewR, h=setscrewDepth+setscrewFudge);
	}
}

/*
Make a pitch bit, oriented with the shortest side facing down and on/along the x axis*/
module makePitchBit(pitch, gearOR, width, depth) {
	translate([-depth,0, -pitch/4]) cube([2*depth, width, pitch/2]);
}

module pitch(pitch, gearOR, width, depth) {
	//5 teeth per .4" (0.80" pitch)
	teeth = (2* PI * gearOR)/pitch;
	echo("Teeth: ");
	echo(teeth);
	teethDegrees = 360/teeth;
	for (i = [0 : teethDegrees : 360]) {
		rotate([0,i,0]) translate([gearOR-depth, 0,0]) makePitchBit(pitch, gearOR, width, depth);
	}
}

function in2mm(m) = m *25.4;