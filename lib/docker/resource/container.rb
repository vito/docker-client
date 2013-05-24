
module Docker
  module Resource
  end
end

class Docker::Resource::Container < Docker::Resource::Base
  # TODO set 'Content-Type: application/json'
  
  # Options
  # all
  # limit
  # since
  # before
  def list(options = {})
    @connection.get('/containers/ps', options).body_as_json
  end
  
  # Create options into JSON body
  def create(command, image = 'base', options = {})
    command = [command] if command.is_a?(String)
    body = {'Cmd' => command, 'Image' => image}
    body = options.merge(body)
    json_body = MultiJson.dump(body)
    
    response = @connection.post("/containers/create", json_body, {'Content-Type' => 'application/json'})
    raise(Docker::Error::NotFoundError) if response.status == 404
    response.body_as_json
  end
  
  # inspect is a Ruby internal method that should not be overwritten 
  # therefore we use show as it displays the container details
  def show(container_id)
    @connection.get("/containers/#{container_id}/json").body_as_json
  end
  
  def changes(container_id)
    @connection.get("/containers/#{container_id}/changes").body_as_json
  end
  
  # Returns a stream
  def export
    
  end
  
  def start(container_id)
    @connection.post("/containers/#{container_id}/start").status
  end
  
  def stop(container_id)
    @connection.post("/containers/#{container_id}/stop").status
  end
  
  # Options:
  # t number of seconds to wait
  def restart(container_id, options = {})
    @connection.post("/containers/#{container_id}/restart").status
  end
  
  def kill(container_id)
    @connection.post("/containers/#{container_id}/kill").status
  end
  
  # Streaming
  # Options
  # logs
  # stream
  # stdin
  # stdout
  # stderr
  def attach(container_id)
    
  end
  
  # Blocks until container exits
  def wait(container_id)
    response = @connection.post("/containers/#{container_id}/wait")
    # TODO error handling in case of 404 or 500
    response.body
  end
  
  # Options:
  # v remove volumes of container
  def remove(container_id, delete_volumes = false)
    params = {v: delete_volumes}
    status = @connection.delete("/containers/#{container_id}", params).status
    raise(Docker::Error::ContainerNotFound) if status == 404
    status == 204
  end
  
end

  








  