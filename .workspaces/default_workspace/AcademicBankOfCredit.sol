//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract AcademicBankOfCredit {



    enum Applied{notApplied,pending,Approved,rejected}

    struct AppliedStudents{
        string stuName;
        address stuAddress;
    }

    struct PendingStudents {
        string stuName;
        string courseName;
        uint courseCredits;
    }

    struct UniversityOutput {
        address uniAdrrss;
        string uniName;
        uint departCount;
    }

    struct PendingStudentsOutput {
        string name;
        address studAddr;
        uint totalCredits;
    }

    struct Department {
        string name;
        mapping(uint => Course) courses;
        uint courseCount;
    }

    struct Course{
        string courseName;
        uint maxCredit;
        uint year;
    } 

    struct University{
        string name;
        address univAddress;
        mapping(uint => Department) departments;
        uint departCount;
    }

    struct Student{
        address univAddress;
        address studentAddress;
        string studentName;
        uint currentYear;
        string departmentName;
        uint totalCredits;
        mapping(uint => Course) completeCourses;
        uint completeCount;
        mapping(uint => Course) inCompleteCourses;
        uint inCompleteCount;
        mapping(uint => Course) pendingCourses;
        uint pendingCourseCount;
        string toUnivName;
        address toUnviAddress;
        Applied status;
    }

    mapping(address => University) public universites;
    address[] listOfUniAddr;

    mapping(address => Student) public students;
    address[] listOfStuAddr;

    function addUniversity(string memory _name)  public{
        University storage u1 = universites[msg.sender];
        u1.name = _name;
        u1.univAddress = msg.sender;
        Department storage d1 = u1.departments[u1.departCount];
        u1.departCount++;
        d1.name = "IT";
        Course storage c1 = d1.courses[d1.courseCount];
        d1.courseCount++;
        c1.courseName="CHEM";
        c1.maxCredit=5;
        c1.year= 1;
        listOfUniAddr.push(msg.sender);
    }

    function stringsEquals(string memory s1, string memory s2) private pure returns (bool) {
        bytes memory b1 = bytes(s1);
        bytes memory b2 = bytes(s2);
        uint256 l1 = b1.length;
        if (l1 != b2.length) return false;
        for (uint256 i=0; i<l1; i++) {
            if (b1[i] != b2[i]) return false;
        }
        return true;
    }

    function addStudent(string memory _name, uint _year,string memory _departName, address _univAddress) public{
        Student storage s1 = students[msg.sender];
        s1.univAddress = _univAddress;
        s1.studentAddress = msg.sender;
        s1.studentName = _name;
        s1.currentYear = _year;
        s1.departmentName = _departName;
        University storage un = universites[_univAddress];
        for(uint i = 0; i < un.departCount; i++){
            if(stringsEquals(un.departments[i].name , _departName)){
                for(uint j = 0; j < un.departments[i].courseCount; j++){
                    Course storage c1 = s1.inCompleteCourses[s1.inCompleteCount];
                    s1.inCompleteCount++;
                    c1.courseName = un.departments[i].courses[j].courseName;
                    c1.maxCredit = un.departments[i].courses[j].maxCredit;
                    c1.year = un.departments[i].courses[j].year;
                }
            }
        }

        listOfStuAddr.push(msg.sender);

    }


    // Get all universtiy
    function getUniversities() public view  returns(UniversityOutput[] memory){
        UniversityOutput[] memory allUniversites = new UniversityOutput[](listOfUniAddr.length);
        uint count = 0;


        for(uint i = 0; i < listOfUniAddr.length; i++){
            allUniversites[count].uniAdrrss = listOfUniAddr[i];
            allUniversites[count].uniName = universites[listOfUniAddr[i]].name;
            allUniversites[count].departCount = universites[listOfUniAddr[i]].departCount;
            count++;
        }

        return allUniversites;

    }

    // getUniversityCourse course
    function getUniversityCourse(address univAddress) public view returns(Course[] memory){
        Course[] memory allUnvCourses = new Course[](16);
        uint count = 0;        
        for(uint i = 0; i < listOfUniAddr.length; i++){

            for(uint j = 0; j < universites[univAddress].departments[i].courseCount; j++) {
                allUnvCourses[count] = universites[univAddress].departments[i].courses[j];
                count++;
            }

        }

        return allUnvCourses;
    }   

    //user details
    function getUserDetails(address studAddr) public view returns(address ,
        address ,
        string memory ,
        uint ,
        string memory ,
        uint ){

        return (students[studAddr].univAddress,studAddr, students[studAddr].studentName, students[studAddr].currentYear, students[studAddr].departmentName, students[studAddr].totalCredits);
    }

    // getUser complete courses
    function getCompletedCourses() public view returns(Course[] memory) {
        Course[] memory completedCourses = new Course[](16);
        uint count = 0;       
        Student storage s1 = students[msg.sender];
        for(uint i = 0; i < s1.completeCount; i++){
            completedCourses[count].courseName = s1.completeCourses[i].courseName;
            completedCourses[count].maxCredit = s1.completeCourses[i].maxCredit;
            completedCourses[count].year = s1.completeCourses[i].year;
            count++;
        }

        return completedCourses;
    }


    // function request course credit 
    function requestCourseCred(string memory courseName) public {

        Student storage s1 = students[msg.sender];

        for(uint i = 0; i < s1.inCompleteCount; i++){
            if(stringsEquals(s1.inCompleteCourses[i].courseName ,courseName)){
                Course storage c1 = s1.pendingCourses[s1.pendingCourseCount];
                s1.pendingCourseCount++;
                c1.courseName = s1.inCompleteCourses[i].courseName;
                c1.maxCredit = s1.inCompleteCourses[i].maxCredit;
                c1.year = s1.inCompleteCourses[i].year;
                delete s1.inCompleteCourses[i];
                s1.inCompleteCount--;
                break;
            }
        }
        
    }


    function pendingCoursesCred() public view returns(PendingStudents[] memory) {
        PendingStudents[] memory pendingStudents= new PendingStudents[](20);
        uint count = 0;   

        for(uint i = 0 ; i < listOfStuAddr.length; i++){
            if(students[listOfStuAddr[i]].univAddress == msg.sender){
                for(uint j = 0 ; j < students[listOfStuAddr[i]].pendingCourseCount; i++){
                    pendingStudents[count].stuName = students[listOfStuAddr[i]].studentName;
                    pendingStudents[count].courseName = students[listOfStuAddr[i]].pendingCourses[j].courseName;
                    pendingStudents[count].courseCredits =students[listOfStuAddr[i]].pendingCourses[j].maxCredit;
                    count++;
                }
            }
        }

        return pendingStudents;

    }


    //  accept student
    function AcceptCourseCred(address stuAddress, string memory courseName) public {
        Student storage s1 = students[stuAddress];
        for(uint i = 0; i < s1.pendingCourseCount; i++){
            if(stringsEquals(s1.pendingCourses[i].courseName , courseName)){
                Course storage c1 = s1.completeCourses[s1.completeCount];
                s1.completeCount++;
                c1.courseName = s1.pendingCourses[i].courseName;
                c1.maxCredit = s1.pendingCourses[i].maxCredit;
                c1.year = s1.pendingCourses[i].year;
                delete s1.pendingCourses[i];
                s1.pendingCourseCount--;
                break;
            }
        }

    }


    function requestTransferUniversity(address _toUnivAddress) public {
        Student storage s1 = students[msg.sender];
        s1.toUnivName = universites[_toUnivAddress].name;
        s1.toUnviAddress = _toUnivAddress;
        s1.status = Applied.pending;
    }

    function transferUniversity(address studAddress) public {
        Student storage s1 = students[studAddress];
        s1.univAddress = msg.sender;
        s1.toUnivName = "";
        s1.status = Applied.Approved;
    }

    function appliedStudents() public view returns(AppliedStudents[] memory){
        AppliedStudents[] memory appliedArray= new AppliedStudents[](20);
        uint count  = 0;
        for(uint i = 0; i < listOfStuAddr.length; i++){

            if(stringsEquals(students[listOfStuAddr[i]].toUnivName, universites[msg.sender].name)){
                appliedArray[count].stuName = students[listOfStuAddr[i]].studentName;
                appliedArray[count].stuAddress = listOfStuAddr[i];
                count++;
            }   

        }

        return appliedArray;
        
    }


}