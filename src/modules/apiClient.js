import networking from './networking'

const Endpoint = {
  sessions: '/sessions',
  projects: '/projects',
  users: '/users'
}

class ApiClient {
  getToken() {
    return networking.getToken()
  }

  setToken(token) {
    networking.setToken(token)
  }

  removeToken() {
    networking.removeToken()
  }

  createUser(form) {
    return networking.post(Endpoint.users, form)
  }

  logIn(form) {
    return networking.post(Endpoint.sessions, form)
  }

  getProjects() {
    return networking.get(Endpoint.projects)
  }

  createProject(form) {
    return networking.post(Endpoint.projects, form)
  }
}

const apiClient = new ApiClient();
export default apiClient
