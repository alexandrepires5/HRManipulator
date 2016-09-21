include <measures.scad>;
    

module horn_single(){
    
  linear_extrude(height = 4, center = false)
      hull(){
       translate([32.5- 7/2, 0, 0]) circle(d = 7, $fn = 32);
       circle(d = 13, $fn = 32);
      }

}