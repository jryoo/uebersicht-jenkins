colors =
  running : '#525252'
  success : '#80b95b'
  failed  : '#C30005'
  standard: '#000000'

command: "python ./jenkins.widget/test.py"

refreshFrequency: 3000

style: """
  margin: 0 auto
  font-family: Myriad Set Pro, Helvetica Neue
  font-weight: 300
  font-smoothing: antialias
  top: 10px
  left: 10px

  td
    padding: 4px 8px
    font-size: 14px
    color: #{colors.standard}

    .status
      margin: 2px 0
      padding: 0
      font-size: 12px
      font-weight: normal
      background-color: #{colors.standard}

  .build_status .status
    width: 10px
    height: 10px
    border: 2px solid
    border-radius: 100%

  .running .status
    border-color: rgba(#{colors.running}, 0.2)
    color: #{colors.running}
    border-top-color: #{colors.running}

  .running .build_status .status
    animation: spin 1s infinite
    animation-timing-function: linear
    background-color: transparent

  .blue .status
    border-color: #{colors.success}
    color: #{colors.success}

  .blue .build_status .status
    background: #{colors.success}

  .red .status
    border-color: #{colors.failed}
    color: #{colors.failed}

  .red .build_status .status
    background: #{colors.failed}
  
  .environmentName
    margin-bottom: 5px
    margin-top: 0px
    margin-left: 8px
    font-weight: 500

  .environmentName.red
    color: red
    
  .environmentName.blue
    color: #{colors.success}
"""

render: -> """
  <div>
    <style>
      @-webkit-keyframes spin {
        from {
          -webkit-transform: rotate(0deg);
        }
        to {
          -webkit-transform: rotate(360deg);
        }
      }
    </style>
    <div id="container">
    </div>
  </div>
"""

update: (output, domEl) ->
  
  renderStackDiv = (env) ->
    """
    <br>
    <div id="#{env.name}">
      <p class="environmentName #{env.homepage_status}"> #{env.name} </p>
      <table id="#{env.name}Table"</table>
    </div>
    """

  renderBuild = (build) ->
    """
    <tr class="#{build.color}">
      <td class="build_status"><div class="status"></div></td>
      <td class="build_branch">
        <span class='branch'>#{ build.name }</span>
      </td>
    </tr>
    """

  parsedOutput = JSON.parse(output)

  # Reset the DOM
  $(domEl).find('#container').empty()

  for id of parsedOutput
    env = parsedOutput[id]
    $(domEl).find('#container').append renderStackDiv(env)
    projects = parsedOutput[id].jobs
    tableName = env.name + "Table";
    table = $(domEl).find('#' + tableName)
    # Reset the table
    table.html('')
    for build in projects
      table.append renderBuild(build)



