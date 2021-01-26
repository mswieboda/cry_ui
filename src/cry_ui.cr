require "iu"

alias GUI = Iu

module CryUI
  # defines global component storage
  COMPONENTS = {} of Symbol => GUI::Component

  class MyComponent < GUI::ReusableComponent
    include GUI::Components

    def initialize(@id : Int32)
      @button = Button.new(text: "Click Me!")

      @button.clicked.on do
        UI.msg_box(COMPONENTS[:window].as(Window).window, "Good Job!", "You have clicked a button!")
      end
    end

    def render : GUI::Component
      Group.new(
        title: "MyComponent",
        margined: true
      ).adopt(
        VerticalBox.new(padded: true).adopt(
          Label.new(text: "Hello, World ##{@id}!")
        ).adopt(
          @button
        )
      )
    end
  end

  class Application < GUI::Application
    include GUI::Components

    def initialize_component
      window = Window.new(
        title: "CryUI",
        width: 800,
        height: 600,
        menu_bar: false
      )

      window.margined = true

      window.adopt(
        HorizontalBox.new(padded: true).adopt(
          MyComponent.new(1),
          stretchy: true
        )
      )

      COMPONENTS[:window] = window

      window.closing.on do
        exit(0)
      end

      window.show
    end
  end
end

app = CryUI::Application.new

app.should_quit.on do
  exit(0)
end

app.start
