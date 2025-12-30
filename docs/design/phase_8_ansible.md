# Phase 8: Ansible - Automation & Configuration Management

> **Objective:** configure our servers (which Terraform created) with security updates and required software.

## 1. Terraform vs Ansible (The Interview Answer)
*   **Terraform (Infrastructure as Code):** Creates the "Skeleton". It spins up the EC2 instance, VPC, and SG.
*   **Ansible (Configuration Management):** Adds the "Muscles". It SSHs into the EC2 instance, runs `yum update`, creates users, and edits config files.
*   *Why not just use UserData?* UserData is hard to test and change later. Ansible is repeatable and trackable.

## 2. Key Concept: Idempotency
*   **Definition:** An operation that produces the same result whether run once or multiple times.
*   **Example:**
    *   *Not Idempotent:* `echo "line" >> file.txt` (Runs twice? Two lines).
    *   *Idempotent (Ansible):* `lineinfile: path=file.txt line="line"` (Runs twice? Checks if line exists, if yes, does nothing).

## 3. The Task: Hardening the Bastion Host
Our Bastion Host is the entry point to our network. We must secure it.
**The Playbook will:**
1.  Update all packages (`yum update`).
2.  Install **Fail2Ban** (Bans IPs that guess passwords).
3.  Disable **Root Login** in SSH (`PermitRootLogin no`).
4.  Install vital tools (`htop`, `vim`).

## 4. Inventory Strategy
We use an **Inventory File** to tell Ansible which servers to target.
*   `[bastion]` group.
*   In real life, we use **Dynamic Inventory** (a script that asks AWS "Which servers are tagged 'bastion'?"), but for clarity, we will use a static `hosts.ini`.

## 5. Work Execution Plan
1.  Create `infrastructure/ansible/inventory/hosts.ini`.
2.  Create `infrastructure/ansible/playbooks/harden_bastion.yml`.
3.  Explain how to run it: `ansible-playbook -i inventory/hosts.ini playbooks/harden_bastion.yml`.

**Key Takeaway for Interviews:**
"I use Ansible for post-provisioning configuration because of its agentless architecture (SSH only) and strong idempotency. While Terraform manages the lifecycle of the resource, Ansible ensures the OS state is compliant with security policies."
