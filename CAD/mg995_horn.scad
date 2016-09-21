


   
module horn_single(){
    
  linear_extrude(height = 4, center = false)
      hull(){
       translate([19-5/2, 0, 0]) circle(d = 4, $fn = 32);
       circle(d = 10, $fn = 32);
      }

}

module horn(){
    for(i=[0:3])
    {
        rotate([0, 0, 90*i])
        horn_single();
    }
} 
