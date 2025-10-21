import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

        mainMenu();
    }

    private static void mainMenu(){
        Scanner myObj = new Scanner(System.in);

        System.out.println("MAIN MENU");
        System.out.println("1. Create account");
        System.out.println("2. Sign in");
        System.out.println("3. Exit");

        int input = myObj.nextInt();

        if(input == 1)
            createMenu();


        if(input == 2)
            signIn();

        if(input == 3)
            exit();
    }

    private static void exit(){
        System.exit(0);
    }

    private static void createMenu(){
        Scanner myObj = new Scanner(System.in);

        System.out.println("CREATE ACCOUNT");
        System.out.println("1. User");
        System.out.println("2. Doctor");
        System.out.println("3. Nurse");
        System.out.println("4. Return to main menu");
        System.out.println("5. Exit");

        int input = myObj.nextInt();

        if(input == 1)
            createUser(true);

        if(input == 2){
            String[] info = createUser(false);
            createDoctor(info);
        }

        if(input == 3){
            String[] info = createUser(false);
            createNurse(info);
        }

        if(input == 4)
            mainMenu();

        if(input == 5)
            exit();
    }

    private static String[] createUser(boolean isUser){
        Scanner myObj = new Scanner(System.in);

        System.out.println("Please type your name, last name, gender, date of your birth, and if you have a specific disease or not");
        String name = myObj.next();
        String lastName = myObj.next();
        String gender = myObj.next();
        String birth = myObj.next();
        String disease = myObj.next();

        System.out.println("Please type your user name(ID) and your password");
        String ID = myObj.next();
        String pass = myObj.next();

        String[] info = new String[]{name,lastName,gender,birth,disease,ID,pass};

        //TODO

        if(isUser)
            createMenu();

        return info;
    }

    private static void createDoctor(String[] info){
        Scanner myObj = new Scanner(System.in);

        System.out.println("Please type your Doctor ID");
        String doctorId = myObj.next();

        //TODO

        createMenu();
    }

    private static void createNurse(String[] info){
        Scanner myObj = new Scanner(System.in);

        System.out.println("Please type your level and nurse ID");
        String level = myObj.next();
        String nurseId = myObj.next();

        //TODO

        createMenu();
    }

    private static void signIn(){
        Scanner myObj = new Scanner(System.in);

        System.out.println("SIGN IN");
        System.out.println("Please type your user name(ID) and your password");
        String ID = myObj.next();
        String pass = myObj.next();

        //TODO
        boolean success = true;

        if(success){
            System.out.println("Signed in successfully...");
            //TODO like tag and save the time of the login
            //TODO who is the user?
            String user = "user";

            if(user.equals("doctor"))
                doctorOperation(ID);

            if(user.equals("nurse"))
                nurseOperation(ID);

            if(user.equals("user"))
                userOperation(ID);
        }

        else{
            System.out.println("Signed in unsuccessfully...");
            mainMenu();
        }
    }

    private static void doctorOperation(String ID){
        Scanner myObj = new Scanner(System.in);

        System.out.println("Choose the operation for doctor:");
        System.out.println("1. Create new brand");
        System.out.println("2. Create new vaccination centre");
        System.out.println("3. Delete an account");
        System.out.println("4. Sign out");
        System.out.println("5. Exit");

        int input = myObj.nextInt();

        if(input == 1){
            createBrand(ID);
            doctorOperation(ID);
        }

        if(input == 2){
            createCentre();
            doctorOperation(ID);
        }

        if(input == 3){
            deleteAccount();
            doctorOperation(ID);
        }

        if(input == 4)
            signIn();

        if(input == 5)
            exit();
    }

    private static void createBrand(String ID){
        Scanner myObj = new Scanner(System.in);

        System.out.println("Please type the brand name, number of doses and gap days between two doses");
        String name = myObj.next();
        String number = myObj.next();
        String gapDays = myObj.next();

        //TODO with id create brand
    }

    private static void createCentre(){
        Scanner myObj = new Scanner(System.in);

        System.out.println("Please type centre name and the address of it");
        String name = myObj.next();
        String address = myObj.next();

        //TODO
    }

    private static void deleteAccount(){
        Scanner myObj = new Scanner(System.in);

        System.out.println("Please type the ID of the user you want to delete");
        String ID = myObj.next();

        //TODO
    }

    private static void nurseOperation(String ID){
        Scanner myObj = new Scanner(System.in);

        System.out.println("Choose the operation for nurse:");
        System.out.println("1. Injection");

        //TODO which level
        String level = "matron";

        if(level.equals("matron"))
            matron(ID);

        else{
            System.out.println("2. Sign out");
            System.out.println("3. Exit");

            int input = myObj.nextInt();

            if(input == 1){
                injection(ID);
                nurseOperation(ID);
            }

            if(input == 2)
                signIn();

            if(input == 3)
                exit();
        }
    }

    private static void matron(String ID){
        Scanner myObj = new Scanner(System.in);

        System.out.println("2. Create new vial");
        System.out.println("3. Sign out");
        System.out.println("4. Exit");

        int input = myObj.nextInt();

        if(input == 1){
            injection(ID);
            nurseOperation(ID);
        }

        if(input == 2){
            createVial();
            nurseOperation(ID);
        }

        if(input == 3)
            signIn();

        if(input == 4)
            exit();
    }

    private static void injection(String ID){
        Scanner myObj = new Scanner(System.in);

        System.out.println("INJECTION");
        System.out.println("Please type the ID of vaccinated person, the vaccination centre and serial number");
        String vaccinatedID = myObj.next();
        String centre = myObj.next();
        String serial = myObj.next();
        String date;
        String vaccinator = ID;

        //TODO
    }

    private static void createVial(){
        Scanner myObj = new Scanner(System.in);
        System.out.println("CREATE VIAL");
        System.out.println("Please type the serial number, brand, production date and number of doses");

        String serial = myObj.next();
        String brand = myObj.next();
        String date = myObj.next();
        String dose = myObj.next();

        //TODO
    }

    private static void userOperation(String ID){
        Scanner myObj = new Scanner(System.in);

        System.out.println("Choose the operation for user:");
        System.out.println("1. View the user information");
        System.out.println("2. Change password");
        System.out.println("3. Rate the vaccination centre");
        System.out.println("4. View the rate of the vaccination centres");
        System.out.println("5. View the number of injections per day");
        System.out.println("6. View the number of vaccinated people for each brand");
        System.out.println("7. View the rate of vaccination centre for each brand");
        System.out.println("8. personalize the rate of the vaccination centre");
        System.out.println("9. Sign out");
        System.out.println("10. Exit");

        int input = myObj.nextInt();

        if(input == 1){
            viewInfo();
            userOperation(ID);
        }

        if(input == 2){
            changePass(ID);
            userOperation(ID);
        }

        if(input == 3){
            rateCentre(ID);
            userOperation(ID);
        }

        if(input == 4){
            viewRate();
            userOperation(ID);

        }

        if(input == 5){
            viewNumberOfInjections();
            userOperation(ID);
        }

        if(input == 6){
            viewNumOfVaccinated();
            userOperation(ID);
        }

        if(input == 7){
            viewRateOfBrands();
            userOperation(ID);
        }

        if(input == 8){
            personalize();
            userOperation(ID);
        }

        if(input == 9)
            signIn();

        if(input == 10)
            exit();
    }

    private static void viewInfo(){
        //TODO
    }

    private static void changePass(String ID){
        Scanner myObj = new Scanner(System.in);

        System.out.println("Please type your new password");
        String pass = myObj.next();

        //TODO
    }

    private static void rateCentre(String ID){
        Scanner myObj = new Scanner(System.in);

        System.out.println("Please type the vaccination centre and your rate to it");
        String name = myObj.next();
        String rate = myObj.next();

        //TODO
    }

    private static void viewRate(){
        //TODO
    }

    private static void viewNumberOfInjections(){
        //TODO
    }

    private static void viewNumOfVaccinated(){
        //TODO
    }

    private static void viewRateOfBrands(){
        //TODO
    }

    private static void personalize(){
        //TODO
    }
}

