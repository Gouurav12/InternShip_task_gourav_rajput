
        document.addEventListener('DOMContentLoaded', () => {
            const themeToggleBtn = document.getElementById('themeToggleBtn');
            const todoInput = document.getElementById('todoInput');
            const searchInput = document.getElementById('searchInput');
            const addTodoBtn = document.getElementById('addTodoBtn');
            const todoList = document.getElementById('todoList');
            const filterBtns = document.querySelectorAll('.filter-btn');

            let todos = JSON.parse(localStorage.getItem('todos')) || [];
            let currentFilter = 'all';
            let searchTerm = '';

            function saveTodos() {
                localStorage.setItem('todos', JSON.stringify(todos));
            }

            function renderTodos() {
                todoList.innerHTML = '';
                const filteredTodos = todos.filter(todo => {
                    const matchesFilter =
                        currentFilter === 'active' ? !todo.completed :
                        currentFilter === 'completed' ? todo.completed :
                        true;
                    const matchesSearch = todo.text.toLowerCase().includes(searchTerm.toLowerCase());
                    return matchesFilter && matchesSearch;
                });

                if (filteredTodos.length === 0) {
                    todoList.innerHTML = `<li class="empty-state">No tasks found</li>`;
                } else {
                    filteredTodos.forEach(todo => {
                        const li = document.createElement('li');
                        li.className = `todo-item ${todo.completed ? 'completed' : ''}`;
                        li.innerHTML = `
                            <input type="checkbox" class="todo-checkbox" ${todo.completed ? 'checked' : ''}>
                            <span class="todo-text">${todo.text}</span>
                            <div class="todo-actions">
                                <button class="todo-btn edit-btn"><i class="fas fa-edit"></i></button>
                                <button class="todo-btn delete-btn"><i class="fas fa-trash-alt"></i></button>
                            </div>
                        `;

                        const checkbox = li.querySelector('.todo-checkbox');
                        const editBtn = li.querySelector('.edit-btn');
                        const deleteBtn = li.querySelector('.delete-btn');
                        const todoText = li.querySelector('.todo-text');

                        checkbox.addEventListener('change', () => {
                            todo.completed = checkbox.checked;
                            saveTodos();
                            renderTodos();
                        });

                        editBtn.addEventListener('click', () => {
                            const isEditing = todoText.contentEditable === "true";
                            if (!isEditing) {
                                todoText.contentEditable = "true";
                                todoText.focus();
                                editBtn.innerHTML = '<i class="fas fa-save"></i>';
                            } else {
                                todoText.contentEditable = "false";
                                todo.text = todoText.innerText;
                                editBtn.innerHTML = '<i class="fas fa-edit"></i>';
                                saveTodos();
                            }
                        });

                        deleteBtn.addEventListener('click', () => {
                            todos = todos.filter(t => t !== todo);
                            saveTodos();
                            renderTodos();
                        });

                        todoList.appendChild(li);
                    });
                }
            }

            filterBtns.forEach(btn => {
                btn.addEventListener('click', () => {
                    currentFilter = btn.getAttribute('data-filter');
                    filterBtns.forEach(b => b.classList.remove('active'));
                    btn.classList.add('active');
                    renderTodos();
                });
            });

            addTodoBtn.addEventListener('click', () => {
                const text = todoInput.value.trim();
                if (text) {
                    todos.push({ text, completed: false });
                    saveTodos();
                    renderTodos();
                    todoInput.value = '';
                }
            });

            searchInput.addEventListener('input', () => {
                searchTerm = searchInput.value;
                renderTodos();
            });

            themeToggleBtn.addEventListener('click', () => {
                document.body.classList.toggle('dark');
                const icon = themeToggleBtn.querySelector('i');
                icon.classList.toggle('fa-sun');
                icon.classList.toggle('fa-moon');
            });

            renderTodos();
        });