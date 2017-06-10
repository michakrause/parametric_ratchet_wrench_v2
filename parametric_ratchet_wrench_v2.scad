use <publicDomainGearV1.1.scad>;
use <../MCAD/shapes.scad>;

nut_size=5.5;
tolerance=.4;

print=1;
size=nut_size+tolerance;
length=min(max(size*5,35),200);
width=max(size,11);
thickness=max(size/4,6);

gear_size=max(size*1.7,15);
head_size=gear_size*1.2;
teeth_width=2.5;
teeth=floor(gear_size/teeth_width*3.1415926-2);
ratchet_pin_size=max(width/16,1.4);
ratchet_spring_thickness=.9;

module handle() {  // Ratchet Head and Handle
    difference() {
        union() {
            cylinder(thickness,head_size/2,head_size/2);
            translate([head_size/3,-width/2,0])
                cube([length-head_size/3-size,width,thickness]);
        }
        union() {
            translate([0,0,-tolerance])
                cylinder(thickness/4+tolerance,gear_size/2-thickness/4+tolerance,gear_size/2+tolerance); 
            translate([0,0,thickness/4])
                cylinder(thickness/2,gear_size/2+tolerance,gear_size/2+tolerance); 
            translate([0,0,3*thickness/4])
                cylinder(thickness/4+tolerance,gear_size/2+tolerance,gear_size/2-thickness/4+tolerance); 
        }
    }
}

module pawl() { 
    intersection() {
        difference() {
            translate([0,gear_size/8,thickness/6-tolerance/2])
                gear(teeth_width,floor(teeth),thickness/3-tolerance,hole_diameter=0);
            translate([0,gear_size/8,0])
                cylinder(size,ratchet_pin_size,ratchet_pin_size,$fn=20);
         }
         union() {
            translate([-width/8,0,0])
                cube([width/4,gear_size,size]);
            translate([0,gear_size/8,0])
                cylinder(thickness/3,ratchet_pin_size*2,ratchet_pin_size*2,$fn=10);
         }
     }
     // Spring
     translate([-width/4.2,gear_size/2.7,0])
        difference() {
            cylinder(thickness/3-tolerance,width/5.5,width/5.5,$fn=10);
            union() {
                cylinder(thickness/3,width/5.5-ratchet_spring_thickness,width/5.5-ratchet_spring_thickness,$fn=10);
                translate([-width/4,gear_size/16,0])
                    cube([width,width,thickness/3]);
            }
        }
}
module gear_head() {
    difference() {
        union() {
            cylinder(thickness/4,gear_size/2-thickness/4,gear_size/2); 
            translate([0,0,thickness/2])
                gear(teeth_width,floor(teeth),thickness/2,size/4);
            translate([0,0,3*thickness/4])
                cylinder(thickness/4,gear_size/2,gear_size/2-thickness/4); 
        }
        translate([0,0,thickness/2-1])
            hexagon(size,thickness+2);
    }
}

module open_end(){
    difference() {
        translate([size/4,0,0])
            cylinder(thickness,size,size);
        union() {
            translate([0,0,thickness/2-1])
                hexagon(size,thickness+2);
            translate([-size,-size,0])
                cube([size/1.37,size*2,thickness]);
        }
    }
}





// Combine Handle 
difference() {
    union() {
        handle();
        translate([length,0,0]) rotate([0,0,180]) open_end();
    }
    union() {
        translate([head_size/2.2,-width/2.4,thickness/3]) {// Handle cutout
            cube([gear_size/1.4,width/1.2,thickness]);
            translate([-head_size/10,0,0]) {
                cube([gear_size/1.4,width/1.2,thickness/3]);
            }
        }
        translate([length-size*2.2,-size/4,thickness-2])
            linear_extrude(height = thickness)
                text(str(nut_size),size=size/2);
    }
}
gear_head();

union() {// Place Ratchet parts
translate([2*pitch_radius(teeth_width,teeth)+gear_size/8+tolerance,1*width*1.5*print,thickness/3-(thickness/3*print)])
    rotate([0,0,90])
        pawl();

// Rachet stop
translate([head_size/2.2,width/8,thickness/3])
    cube([gear_size/8,width/3,thickness/3]);

// ratchet angle point
translate([2*pitch_radius(teeth_width,teeth)+tolerance,0,thickness/3])
    cylinder(thickness/3,ratchet_pin_size-tolerance,ratchet_pin_size-tolerance,$fn=20);
}

//cover
translate([head_size/2.2+width*print,-width/2.4+width*1.2*print,2*thickness/3-(2*thickness/3*print)])
cube([gear_size/1.4,width/1.2,thickness/3]);
