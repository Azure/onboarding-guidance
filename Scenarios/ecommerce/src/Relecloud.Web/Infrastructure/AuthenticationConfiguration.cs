namespace Relecloud.Web.Infrastructure
{
    public class AuthenticationConfiguration
    {
        #region Configuration Bound Properties

        public string ClientId { get; set; }
        public string Tenant { get; set; }
        public string SignUpSignInPolicyId { get; set; }
        public string ResetPasswordPolicyId { get; set; }
        public string EditProfilePolicyId { get; set; }

        #endregion

        #region Derived Properties

        public string DefaultPolicy => SignUpSignInPolicyId;
        public string Authority => $"https://login.microsoftonline.com/tfp/{Tenant}/{DefaultPolicy}/v2.0";

        #endregion
    }
}