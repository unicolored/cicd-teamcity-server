module.exports = ({ env }) => ({
  // ...
  email: {
    config: {
      provider: "strapi-provider-email-postmark",
      providerOptions: {
        apiKey: "{{strapi_postmark_api_key}}",
      },
      settings: {
        defaultMessageStream: "{{strapi_postmark_stream}}",
        defaultFrom: "{{strapi_smtp_from_email}}",
        defaultTo: "{{strapi_admin_email}}",
        defaultReplyTo: "{{strapi_smtp_from_email}}",
        defaultVariables: {
          sentBy: 'strapi',
        },
      },
    }
  },
  // ...
});
