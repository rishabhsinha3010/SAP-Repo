// namespace poapplication;

// //identifier decleration 

// // type ![EmployeeName] : String(50);

// using {poapplication.common as common} from './common';

// using {managed, temporal} from '@sap/cds/common';

// entity Students : common.address, common.fees {
//     key studentId : common.id;
//     studentName : common.nameStr;
//     fatherName : common.nameStr;
//     motherName : common.nameStr;
//     contactNo : common.PhoneNumber;
//     gender : common.Gender;
//     email : common.Email;
//     //managed association
//     class : Association to Classes;
//     //unmanaged association
//     bookId : Association to many Librarys on bookId.parent = $self;
// }

// entity Classes : common.address {
//     key classId : common.id;
//     className : common.nameStr;
//     teacherName : common.nameStr;
// }

// // entity Employees {
// //     key empId : Integer;
// //     empName: String(20);
// //     salary: Integer;
// //     dept: String(50);
// //     currency: String(50);
// //     city: String(50);
// //     country: String(50);
// //     class : Association to one Division;
// // }

// // entity Division{
// //     key divId : Integer;
// //     divName: String(20);
// //     divCity: String(20);
// //     divCountry: String(20);
// // }

// entity Librarys{
//     key bookId : Integer;
//     parent : Association to Students;
//     bookName : common.nameStr;
//     issueDate : Date;
//     Status : common.Book;
//     returnDate : Date;
//     AuthorName : common.nameStr;
// }


namespace poapplication;

entity Albums {
    key Alb_ID      : Integer;
    Title           : String(120);
    Description     : String(255);
    View            : Integer;
    Photos          : Association to many Photos on Photos.Album = $self;
}

entity Location {
    key Location_ID : Integer;
    Name            : String(50);
    Shortname       : String(50);
    Photos          : Association to many Photos on Photos.Location = $self;
}

entity Member {
    key Member_ID   : Integer;
    Name            : String(255);
    PhoneNum        : String(20);
    Email           : String(200);
    Address         : String(255);
    // write the condition yourself that's why unmanaged association
    Photos          : Association to many Photos on Photos.Member = $self;
}


entity Photos {
    key Photo_ID    : Integer;
    Album           : Association to Albums;
    Location        : Association to Location;
    Member          : Association to Member;
    Title           : String(120);
    Description     : String(255);
    Privacy         : String(20);
    UploadDate      : Date;
    View            : Integer;
    ImagePath       : String(50);
    Comments        : Association to many Comment on Comments.Photo = $self;
    PhotoTags       : Association to many Tag_Photo on PhotoTags.Photo = $self;
}


entity Comment {
    key Comment_ID  : Integer;
    Photo           : Association to Photos;
    PostDate        : Date;
    Content         : String(255);
}


entity Tag {
    key Tag_ID      : Integer;
    Title           : String(120);
    PhotoTags: Association to many Tag_Photo on PhotoTags.Tag = $self;
}


entity Tag_Photo {
    key ID          : Integer;
    Tag             : Association to Tag;
    Photo           : Association to Photos;
}