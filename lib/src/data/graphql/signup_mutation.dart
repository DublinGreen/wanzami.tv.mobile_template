const String signupUserQuery = r'''
mutation CreateUser($firstName: String!, $lastName: String!, $email: String!, $password: String!) {
  createUser(
    firstName: $firstName
    lastName: $lastName
    email: $email
    password: $password
  ) {
    id
    status
    firstName
    lastName
    email
    role
  }
}
''';