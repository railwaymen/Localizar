import networking from './networking'

const Endpoint = {
  locales: () => '/locales',
  projects: (slug) => '/projects' + (!slug ? '' : ('/' + slug)),
  sessions: () => '/sessions',
  translations: (projectSlug) => '/projects/' + projectSlug + '/translations',
  users: () => '/users'
}

class ApiClient {
  // locales
  getLocales = () => networking.get(Endpoint.locales())

  // projects
  getProjects = () => networking.get(Endpoint.projects())
  getProject = (slug) => networking.get(Endpoint.projects(slug))
  createProject = (form) => networking.post(Endpoint.projects(), form)
  
  // translations
  getTranslations = (projectSlug, options) => networking.get(Endpoint.translations(projectSlug), { params: options })

  // sessions
  logIn = (form) => networking.post(Endpoint.sessions(), form)

  // users
  createUser = (form) => networking.post(Endpoint.users(), form)

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
