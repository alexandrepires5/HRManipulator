include <horn_mg946r.scad>;
include <measures.scad>;

module motor(){
    cube(size = [20,40.3,36.6], center = true);
    translate([0,0,26.6/2]) 
        cube(size = [20,53.6,2.5], center = true);
    translate([0,mg946r_length*1/2-8,36.6/2]) rotate([0,0,$t*180]) 
        cylinder(d=12, h=4.5);     
    translate([0,mg946r_length*1/2-8,42/2]) rotate([0,0,$t*180])
        horn_single();
}