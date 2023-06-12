@IsTest
public class LoginAuthenticationTest {

    static testMethod void testLogin() {
        // Create test user
        User testUser = new User('test', 'test123');
        // Create test LoginAuthentication
        LoginAuthentication testLogin = new LoginAuthentication(testUser.username, testUser.password);
        // Call login method
        testLogin.login();
        // Check if login was successful
        System.assertEquals('User logged in successfully.', testLogin.login());
    }

    static testMethod void testResetPassword() {
        // Create test user
        User testUser = new User('test', 'test123');
        // Create test LoginAuthentication
        LoginAuthentication testLogin = new LoginAuthentication(testUser.username, testUser.password);
        // Call resetPassword method
        testLogin.resetPassword();
        // Check if password was reset successfully
        System.assertEquals('ABC123', testLogin.resetPassword());
    }

    static testMethod void testLogout() {
        // Create test user
        User testUser = new User('test', 'test123');
        // Create test LoginAuthentication
        LoginAuthentication testLogin = new LoginAuthentication(testUser.username, testUser.password);
        // Call logout method
        testLogin.logout();
        // Check if user was logged out successfully
        System.assertEquals('User logged out successfully.', testLogin.logout());
    }
}