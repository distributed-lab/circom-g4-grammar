bus B1 {
    signal x;
}

bus B2() {
    signal x;
}

template B1toB2(){
    input B1() b1;
    output B2() b2;
    b2 <== b1;
}

bus Film() {
    signal title[50];
    signal director[50];
    signal year;
}

bus Date() {
    signal day;
    signal month;
    signal year;
}

bus Person() {
    signal name[50];
    Film() films[10];
    Date() birthday;
}

bus Line(dim){
    PointN(dim) start;
    PointN(dim) end;
}

bus Figure(num_sides, dim){
    Line(dim) side[num_sides];
}

bus Triangle2D(){
    Figure(3,2) {well_defined} triangle;
}

bus Square3D(){
    Figure(4,3) {well_defined} square;
}

template well_defined_figure(num_sides, dimension){
    input Figure(num_sides,dimension) t;
    output Figure(num_sides,dimension) {well_defined} correct_t;
    var all_equals = 0;
    var isequal = 0;
    for(var i = 0; i < num_sides; i=i+1){
        for(var j = 0; j < dimension; j=j+1){
            isequal = IsEqual()([t.side[i].end.x[j],t.side[(i+1)%num_sides].start.x[j]]);
            all_equals += isequal;
        }
    }
    all_equals === num_sides;
    correct_t <== t;
}

template Edwards2Montgomery () {
 input Point() { edwards_point } in ;
 output Point() { montgomery_point } out ;

 out.x <-- (1 + in.y ) / (1 - in.y ) ;
 out.y <-- out.x / in.x ;

 out.x * (1 - in.y ) === (1 + in.y ) ;
 out.y * in.x === out.x ;
}