const API_URL = "YOUR_API_URL";

let editingNoteId = null;

async function saveOrUpdateNote() {
  const titleInput = document.getElementById("titleInput");
  const title = titleInput.value.trim();

  if (!title) {
    alert("Please enter a note title");
    return;
  }

  try {
    if (editingNoteId) {
      const response = await fetch(`${API_URL}/notes/${editingNoteId}`, {
        method: "PUT",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ title })
      });

      const data = await response.json();
      console.log("Update response:", data);
      alert("Note updated");
    } else {
      const response = await fetch(`${API_URL}/notes`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ title })
      });

      const data = await response.json();
      console.log("Save response:", data);
      alert("Note saved");
    }

    titleInput.value = "";
    cancelEdit();
    loadNotes();
  } catch (error) {
    console.error("Save/update error:", error);
    alert("Something went wrong.");
  }
}

async function loadNotes() {
  try {
    const response = await fetch(`${API_URL}/notes`);
    const data = await response.json();

    console.log("Raw API response:", data);

    let notes = [];

    if (Array.isArray(data)) {
      notes = data;
    } else if (data.body) {
      notes = JSON.parse(data.body);
    }

    const notesList = document.getElementById("notesList");
    const emptyState = document.getElementById("emptyState");

    notesList.innerHTML = "";

    if (!notes.length) {
      emptyState.classList.remove("hidden");
      return;
    }

    emptyState.classList.add("hidden");

    notes.forEach(note => {
      const li = document.createElement("li");
      li.className = "note-item";

      li.innerHTML = `
        <div class="note-title">${note.title}</div>
        <div class="note-actions">
          <button class="secondary" onclick="startEdit('${note.id}', \`${escapeTemplate(note.title)}\`)">Edit</button>
          <button class="danger" onclick="deleteNote('${note.id}')">Delete</button>
        </div>
      `;

      notesList.appendChild(li);
    });
  } catch (error) {
    console.error("Load notes error:", error);
    alert("Failed to load notes.");
  }
}

function startEdit(id, title) {
  editingNoteId = id;
  document.getElementById("titleInput").value = title;
  document.getElementById("formTitle").textContent = "Edit Note";
  document.getElementById("cancelEditBtn").classList.remove("hidden");
}

function cancelEdit() {
  editingNoteId = null;
  document.getElementById("titleInput").value = "";
  document.getElementById("formTitle").textContent = "Add a Note";
  document.getElementById("cancelEditBtn").classList.add("hidden");
}

async function deleteNote(id) {
  const confirmed = confirm("Delete this note?");
  if (!confirmed) return;

  try {
    const response = await fetch(`${API_URL}/notes/${id}`, {
      method: "DELETE"
    });

    const data = await response.json();
    console.log("Delete response:", data);

    alert("Note deleted");
    loadNotes();
  } catch (error) {
    console.error("Delete error:", error);
    alert("Failed to delete note.");
  }
}

function escapeTemplate(str) {
  return String(str).replace(/`/g, "\\`");
}

loadNotes();
