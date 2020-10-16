import networking from './networking'

const Endpoint = {
  locales: '/locales',
  projects: '/projects',
  sessions: '/sessions',
  users: '/users'
}

class ApiClient {
  // locales
  getLocales = () => networking.get(Endpoint.locales)

  // projects
  getProjects = () => networking.get(Endpoint.projects)
  createProject = (form) => networking.post(Endpoint.projects, form)

  // sessions
  logIn = (form) => networking.post(Endpoint.sessions, form)

  // users
  createUser = (form) => networking.post(Endpoint.users, form)

  // Token management
  getToken() {
    return networking.getToken()
  }

  setToken(token) {
    networking.setToken(token)
  }

  removeToken() {
    networking.removeToken()
  }
}

const apiClient = new ApiClient();
export default apiClient
