import networking from './networking'

const toURLParameter = (parameter) => {
  return parameter
    ? "/" + parameter
    : ""
}

const Endpoint = {
  locales: () => '/locales',
  projects: (slug) => '/projects' + toURLParameter(slug),
  sessions: () => '/sessions',
  translations: (projectSlug, translationID) => '/projects/' + projectSlug + '/translations' + toURLParameter(translationID),
  users: () => '/users'
}

class ApiClient {
  // locales
  getLocales = () => networking.get(Endpoint.locales())

  // projects
  getProjects = () => networking.get(Endpoint.projects())
  getProject = (slug) => networking.get(Endpoint.projects(slug))
  createProject = (form) => networking.post(Endpoint.projects(), form)
  updateProject = (project) => networking.put(Endpoint.projects(project.slug), project)
  
  // translations
  getTranslations = (projectSlug, options) => networking.get(Endpoint.translations(projectSlug), { params: options })
  createTranslation = (projectSlug, data) => networking.post(Endpoint.translations(projectSlug), data)
  deleteTranslation = (projectSlug, translationID) => networking.delete(Endpoint.translations(projectSlug, translationID))

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
