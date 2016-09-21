include <mg995_horn.scad>;
include <measures.scad>;

motor_length = 40;
motor_width = 20;
motor_height = 39;

motor_total_height = 42;
motor_total_length = 54;

motor_partial_height_b = 27;
motor_partial_height_w = 3;

module motor_mg995(){
    cube(size = [motor_width,motor_length,motor_height], center = true);
    translate([0,0,motor_partial_height_b/2]) 
        cube(size = [motor_width,motor_total_length,motor_partial_height_w], center = true);
    translate([0,motor_length*1/2-9.5,motor_height/2]) rotate([0,0,$t*180]) 
        cylinder(d=6, h=5);     
    translate([0,motor_length*1/2-9.5,motor_total_height/2+3]) rotate([0,0,$t*180])
        horn();
}

//motor_mg995();